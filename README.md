# Flutter Weather App

A modern weather application developed with Flutter, as a recruitment assessment for AquaTech Innovation.

---

## Features

- **City-based weather search**  
  Enter a city name to fetch weather data.  
  If multiple cities share the same name, the app lets the user select the correct one using additional details (country, region).

- **Forecast interval selection**  
  Choose a forecast interval:
    - Next 24 hours
    - Next 48 hours
    - Next 72 hours  
      The app displays detailed, hour-by-hour forecasts for the selected range.

- **Customizable light/dark theme**  
  The user can switch between light, dark, or system default themes at any time.

- **Detailed hourly weather display**  
  For each hour in the selected interval, the following are displayed:
    - Temperature
    - Feels like temperature
    - Humidity
    - Wind
    - Precipitation
    - Cloud cover
    - Day/night indicator

- **Responsive UI**  
  The interface automatically adapts to mobile, tablet, desktop, and web screens.

- **Error handling**  
  The app displays clear error messages if city lookup fails or if the weather API is unavailable.

---

## Getting Started

### Prerequisites

- [Flutter](https://flutter.dev/docs/get-started/install) (version 3.x or higher)
- An IDE (VSCode, Android Studio, etc.)
- An emulator or physical device (recommended for best experience)

### Run the App

1. **Clone the repository**
   ```bash
   git clone https://github.com/LenderDiam/flutter_weather_app.git
   cd flutter_weather_app
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Run on web**
   ```bash
   flutter run -d chrome
   ```
   **Or on mobile** (recommended for best experience):
   ```bash
   flutter run
   ```

---

## Dependencies

- **google_fonts**  
  For easy use of Google Fonts, enhancing UI readability and style.

- **http**  
  Used for making HTTP requests to the Open-Meteo API and the geocoding API for city lookup.

- **cupertino_icons**  
  Provides modern iOS-style icons for a consistent, cross-platform UI.

---

## Project Structure

```
lib/
├── main.dart                  # Application entry point
├── screens/
│   └── home_screen.dart       # Main screen: city search and weather display
├── widgets/
│   ├── grid_item_tile.dart    # Metrics tile widget (temperature, humidity, etc.)
│   └── hourly_forecast_card.dart # Widget for each hourly forecast
├── models/                    # Data models for weather, city, etc.
├── services/
│   ├── weather_service.dart   # Handles Open-Meteo API requests
│   └── geocoding_service.dart # Resolves city names to coordinates
└── utils/                     # Utility functions (formatting, conversions, etc.)
```

---

## Author

- LenderDiam
- aurelien.gougis@ecoles-epsi.net

---

## License

This project is provided solely for the AquaTech Innovation technical recruitment assessment.