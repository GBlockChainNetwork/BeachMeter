# Arhitectură

```mermaid
graph TD
    User[User App] --> GPS
    GPS --> Backend
    Backend --> APIs[Open-Meteo / NOAA]
    APIs --> Alerts[Alerte Recurente]
```