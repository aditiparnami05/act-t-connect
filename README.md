<<<<<<< HEAD
# Act-T Connect

Premium Business ERP / Billing / Inventory / CRM built with Flutter.

## Features

- **Dashboard** — KPIs, charts, quick actions, recent transactions
- **Invoices** — Create, view, PDF preview, print & share
- **Inventory** — Products, categories, stock status, barcode-ready
- **Parties** — Customers & suppliers with outstanding balances
- **Purchases & Payments** — Bills, receive/make payments
- **Reports & Analytics** — Sales, GST, P&L with PDF/Excel export
- **Settings** — Dark mode, offline mode, backup, business profile

## Tech Stack

| Layer | Technology |
|-------|------------|
| Framework | Flutter 3.x |
| Architecture | Clean Architecture (feature-first) |
| State | Riverpod |
| Navigation | Go Router |
| Local DB | Hive |
| API Ready | Dio REST client |
| Charts | fl_chart |

## Getting Started

```bash
flutter pub get
flutter run
```

### Demo Login

- **Email:** `admin@acttconnect.com`
- **Password:** `admin123`

## Project Structure

```
lib/
├── main.dart / bootstrap.dart / app.dart
├── core/
│   ├── constants/     # Colors, dimensions, strings
│   ├── theme/         # Material 3 light/dark themes
│   ├── router/        # GoRouter configuration
│   ├── network/       # Dio API client
│   ├── database/      # Hive service
│   ├── utils/         # Formatters, extensions
│   └── widgets/       # Reusable UI components
├── shared/
│   ├── models/        # Domain models
│   ├── data/          # Dummy data & repositories
│   └── providers/     # Riverpod data providers
└── features/
    ├── auth/
    ├── dashboard/
    ├── invoices/
    ├── inventory/
    ├── parties/
    ├── customers/
    ├── suppliers/
    ├── purchases/
    ├── payments/
    ├── reports/
    ├── expenses/
    ├── analytics/
    ├── employees/
    ├── settings/
    └── shell/         # Bottom nav + drawer
```

## Design System

- Primary: `#1976D2` | Secondary: `#2196F3` | Accent: `#42A5F5`
- Background: `#F5F9FF` | Border radius: `18px`
- Material Symbols Rounded icons
- Gradient buttons, glass cards, skeleton loading

## License

Proprietary — Act-T Connect © 2026
=======
# act-t-connect
>>>>>>> 30c27c521a9753f22138867ee59a60200b293ccb
