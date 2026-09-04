# 🚀 Misson App

Misson is an AI-powered gamified learning platform that allows parents to turn static educational content (PDFs, images, documents) into dynamic, interactive mini-games for their children. It tracks learning progress, identifies weak concepts, and adaptively recommends practice missions to ensure concept mastery.

This project is built using:
- **Frontend**: Flutter (Riverpod, GoRouter, Dio, Hive)
- **Backend**: Python FastAPI (SQLAlchemy, SQLite/MySQL, Pydantic)
- **AI Engine**: Claude 3.5 Sonnet (for content extraction and game generation)

---

## 📱 Features
### For Parents
- **Upload Content**: Upload lessons in PDF, TXT, or Image format.
- **AI Game Generation**: Instantly converts lesson materials into rich adaptive missions.
- **Progress Tracking**: View detailed AI-generated reports on the child's strengths and weaknesses.
- **Multiple Profiles**: Manage multiple children with individual progress profiles.

### For Children
- **Gamified Learning**: Earn XP, level up, and unlock achievements and streaks.
- **Interactive Missions**: Play multiple-choice, matching, sequence ordering, and boss-battle game levels.
- **Adaptive Practice**: Automatically focuses on weak concepts to help the child improve and achieve mastery.

---

## 🏗️ Project Structure
`
misson/
├── app/                  # Flutter application
│   ├── lib/              # Main Dart code
│   │   ├── config/       # Environment configs & routing
│   │   ├── core/         # Network, Storage, Theming, Errors
│   │   ├── features/     # UI Layer (Parent, Child, Games, Auth)
│   │   ├── models/       # Pydantic-equivalent Dart domain models
│   │   └── services/     # API integration
│   └── pubspec.yaml      
├── backend/              # FastAPI python application
│   ├── app/
│   │   ├── api/          # Endpoints & Routers
│   │   ├── models/       # SQLAlchemy ORM Models
│   │   ├── schemas/      # Pydantic validation schemas
│   │   └── services/     # Business logic & AI generation
│   ├── requirements.txt  # Python dependencies
│   └── run.py            # Uvicorn entry point
└── README.md             # This file
`

---

## 🛠️ Setup Instructions

### 1. Setup Backend
You need Python 3.10+ installed.

`ash
cd backend
# Create a virtual environment (recommended)
python -m venv venv
# Windows: venv\Scripts\activate | Mac/Linux: source venv/bin/activate

# Install dependencies
pip install -r requirements.txt

# Run the backend
python run.py
`
> The API will be available at http://127.0.0.1:8000. By default, SQLite is used for rapid prototyping.

### 2. Setup Frontend (Flutter)
You need Flutter SDK 3.44+ installed.

`ash
cd app
# Get packages
flutter pub get

# Generate Riverpod, JSON Serializable & Hive models
flutter pub run build_runner build --delete-conflicting-outputs

# Run the app
flutter run
`

---

## ⚙️ Configuration
**Network Issues on Android Emulator?**
If running on an Android Emulator, the piBaseUrl in pp/lib/config/app_config.dart automatically switches to http://10.0.2.2:8000/api/v1 to point to your host machine's backend. Ensure your FastAPI server is running on the default 8000 port.

---

## 🎮 Development Phases Completed
1. **Foundation & Architecture**: Setup Flutter/FastAPI infra, riverpod, models.
2. **Auth & Profiles**: User registration, JWT auth, Child profiles CRUD.
3. **Upload & AI Analysis**: FastAPI parsing, Claude knowledge map extraction, UI progress stepper.
4. **Game Engine**: Dynamic generation of 4-level missions + Boss battle, Flutter game renderers.
5. **Mastery Engine**: Response time + accuracy calculations, adaptive weak-concept grouping, UI reports.
6. **Parent Dashboard**: Home screen, Upload UX, Settings, Child Management.
7. **Child Gamification**: Missions Hub, XP tracking, Confetti Achievements, Leveling up.
8. **End-to-End Verification & Polish**: Network debugging, testing.
