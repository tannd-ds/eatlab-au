from shapely.geometry import Point

class TrackedObject:
    def __init__(self, track_id: int, centroid: tuple[int, int], zone: str, current_time: float):
        self.track_id = track_id
        self.current_zone = zone
        self.dwell_start_time = current_time
        self.history = [zone]

        if isinstance(centroid, Point):
            self.centroid = (int(centroid.x), int(centroid.y))
        else:
            self.centroid = centroid

    def update_position(self, 
                        centroid: Point, 
                        new_zone: str | None, 
                        current_time: float) -> dict | None:
        """Updates the object's position and zone, generating an event if the zone changes."""
        if centroid != (-1, -1):
            if isinstance(centroid, Point):
                self.centroid = (int(centroid.x), int(centroid.y))
            else:
                self.centroid = centroid

        if new_zone != self.current_zone:
            event = self._create_transition_event(new_zone, current_time)
            
            if new_zone:
                # move to a new zone
                self.current_zone = new_zone
                self.dwell_start_time = current_time
                self.history.append(new_zone)
            else:
                # left all zones
                self.current_zone = None

            return event
        return None

    def _create_transition_event(self, to_zone: str | None, current_time: float) -> dict:
        """Creates an event for a zone change."""
        dwell_time = round(current_time - self.dwell_start_time, 2)
        event_type = "lost" if to_zone is None else "move"
        
        return {
            "event": f"item_{event_type}",
            "track_id": self.track_id,
            "from_zone": self.current_zone,
            "to_zone": to_zone,
            "dwell_time": dwell_time,
        }

    def details(self, current_time: float) -> dict:
        return {
            "zone": self.current_zone,
            "dwell_time": round(current_time - self.dwell_start_time, 2),
            "history": self.history,
            "centroid": self.centroid,
        }