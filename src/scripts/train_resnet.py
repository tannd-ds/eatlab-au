import os
import torch
import torch.nn as nn
import torch.optim as optim
from torch.utils.data import Dataset, DataLoader
from torchvision import transforms
from torchvision.models import resnet18, ResNet18_Weights
from PIL import Image
import copy
import mlflow
import mlflow.pytorch

def get_paths_and_labels(data_dir):
    base_dir = os.path.join(data_dir, 'datasets/AU/Dataset/Classification')
    dish_empty_dir = os.path.join(base_dir, 'dish', 'empty')
    tray_empty_dir = os.path.join(base_dir, 'tray', 'empty')
    dish_not_empty_dir = os.path.join(base_dir, 'dish', 'not_empty')
    tray_not_empty_dir = os.path.join(base_dir, 'tray', 'not_empty')
    dish_kakigori_dir = os.path.join(base_dir, 'dish', 'kakigori')
    tray_kakigori_dir = os.path.join(base_dir, 'tray', 'kakigori')

    paths_and_labels = []

    # Class 2: empty
    for img_file in os.listdir(dish_empty_dir):
        if img_file.lower().endswith(('.png', '.jpg', '.jpeg')):
            paths_and_labels.append((os.path.join(dish_empty_dir, img_file), 0))
    for img_file in os.listdir(tray_empty_dir):
        if img_file.lower().endswith(('.png', '.jpg', '.jpeg')):
            paths_and_labels.append((os.path.join(tray_empty_dir, img_file), 0))

    # Class 0: not_empty_dish
    for img_file in os.listdir(dish_not_empty_dir):
        if img_file.lower().endswith(('.png', '.jpg', '.jpeg')):
            paths_and_labels.append((os.path.join(dish_not_empty_dir, img_file), 1))
    for img_file in os.listdir(tray_not_empty_dir):
        if img_file.lower().endswith(('.png', '.jpg', '.jpeg')):
            paths_and_labels.append((os.path.join(tray_not_empty_dir, img_file), 1))

    # Class 1: kakigori
    for img_file in os.listdir(dish_kakigori_dir):
        if img_file.lower().endswith(('.png', '.jpg', '.jpeg')):
            paths_and_labels.append((os.path.join(dish_kakigori_dir, img_file), 2))
    for img_file in os.listdir(tray_kakigori_dir):
        if img_file.lower().endswith(('.png', '.jpg', '.jpeg')):
            paths_and_labels.append((os.path.join(tray_kakigori_dir, img_file), 2))


    return paths_and_labels

class CustomImageDataset(Dataset):
    def __init__(self, paths_and_labels, transform=None):
        self.paths_and_labels = paths_and_labels
        self.transform = transform
        self.classes = ['empty', 'not_empty', 'kakigori']

    def __len__(self):
        return len(self.paths_and_labels)

    def __getitem__(self, idx):
        img_path, label = self.paths_and_labels[idx]
        image = Image.open(img_path).convert('RGB')
        if self.transform:
            image = self.transform(image)
        return image, label

def train_model(model, criterion, optimizer, train_loader, val_loader, num_epochs=25):
    best_model_wts = copy.deepcopy(model.state_dict())
    best_acc = 0.0
    
    device = torch.device("cuda:0" if torch.cuda.is_available() else "cpu")
    model.to(device)

    for epoch in range(num_epochs):
        print(f'Epoch {epoch}/{num_epochs - 1}')
        print('-' * 10)

        for phase in ['train', 'val']:
            if phase == 'train':
                model.train()
                dataloader = train_loader
            else:
                model.eval()
                dataloader = val_loader

            running_loss = 0.0
            running_corrects = 0
            
            for inputs, labels in dataloader:
                inputs = inputs.to(device)
                labels = labels.to(device)

                optimizer.zero_grad()

                with torch.set_grad_enabled(phase == 'train'):
                    outputs = model(inputs)
                    _, preds = torch.max(outputs, 1)
                    loss = criterion(outputs, labels)

                    if phase == 'train':
                        loss.backward()
                        optimizer.step()

                running_loss += loss.item() * inputs.size(0)
                running_corrects += torch.sum(preds == labels.data)

            epoch_loss = running_loss / len(dataloader.dataset)
            epoch_acc = running_corrects.double() / len(dataloader.dataset)
            
            if phase == 'train':
                mlflow.log_metric("train_loss", epoch_loss, epoch)
                mlflow.log_metric("train_acc", epoch_acc, epoch)
            else:
                mlflow.log_metric("val_loss", epoch_loss, epoch)
                mlflow.log_metric("val_acc", epoch_acc, epoch)

            print(f'{phase} Loss: {epoch_loss:.4f} Acc: {epoch_acc:.4f}')

            if phase == 'val' and epoch_acc > best_acc:
                best_acc = epoch_acc
                best_model_wts = copy.deepcopy(model.state_dict())
                torch.save(model.state_dict(), 'best_model.pth')
                mlflow.pytorch.log_model(model, "best_model")

    print(f'Best val Acc: {best_acc:4f}')
    model.load_state_dict(best_model_wts)
    return model

def main():
    data_dir = '.' # Assumes script is run from project root
    
    # MLflow setup
    mlflow.set_tracking_uri(os.environ.get("MLFLOW_TRACKING_URI", "http://localhost:5000"))
    mlflow.set_experiment('dispatch_classifier')
    
    data_transforms = {
        'train': transforms.Compose([
            transforms.RandomResizedCrop(224),
            transforms.RandomHorizontalFlip(),
            transforms.ToTensor(),
            transforms.Normalize([0.485, 0.456, 0.406], [0.229, 0.224, 0.225])
        ]),
        'val': transforms.Compose([
            transforms.Resize(256),
            transforms.CenterCrop(224),
            transforms.ToTensor(),
            transforms.Normalize([0.485, 0.456, 0.406], [0.229, 0.224, 0.225])
        ]),
    }

    paths_and_labels = get_paths_and_labels(data_dir)
    train_size = int(0.8 * len(paths_and_labels))
    val_size = len(paths_and_labels) - train_size
    
    # Manual split of paths and labels
    indices = torch.randperm(len(paths_and_labels)).tolist()
    train_paths_and_labels = [paths_and_labels[i] for i in indices[:train_size]]
    val_paths_and_labels = [paths_and_labels[i] for i in indices[train_size:]]

    train_dataset = CustomImageDataset(train_paths_and_labels, transform=data_transforms['train'])
    val_dataset = CustomImageDataset(val_paths_and_labels, transform=data_transforms['val'])

    train_loader = DataLoader(train_dataset, batch_size=32, shuffle=True, num_workers=2)
    val_loader = DataLoader(val_dataset, batch_size=32, shuffle=False, num_workers=2)

    model = resnet18(weights=ResNet18_Weights.IMAGENET1K_V1)
    num_ftrs = model.fc.in_features
    model.fc = nn.Linear(num_ftrs, 3) # 3 classes

    criterion = nn.CrossEntropyLoss()
    optimizer = optim.SGD(model.parameters(), lr=0.001, momentum=0.9)

    with mlflow.start_run() as run:
        mlflow.log_param("learning_rate", 0.001)
        mlflow.log_param("optimizer", "SGD")
        mlflow.log_param("epochs", 25)
        mlflow.log_param("batch_size", 32)
        
        print(f"MLflow Run ID: {run.info.run_id}")
        train_model(model, criterion, optimizer, train_loader, val_loader, num_epochs=25)

if __name__ == '__main__':
    main() 