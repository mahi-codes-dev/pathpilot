<!-- # pathpilot

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference. -->
# 🚀 PathPilot — Smart Companion for Student Life & Career Clarity

PathPilot is an **offline-first, AI-powered Flutter application** designed to help students gain clarity in **studies, career planning, time management, and personal finance** — all in one place.

It is built with a **production-grade architecture** using Flutter, Firebase, SQLite, and Gemini AI, making it reliable, scalable, and hackathon-ready.

---

## 🎯 Problem Statement

Many students struggle not because of a lack of ability, but due to:

- Confusion about what to study and how to stay consistent
- Uncertainty in choosing the right career path
- Poor time management between academics and personal life
- Lack of financial awareness and expense tracking
- Dependence on scattered, generic online resources

There is no single platform that provides **personalized, structured, and actionable guidance**.

---

## 💡 Solution — PathPilot

PathPilot acts as a **digital companion** that helps students:

- Plan and track their studies
- Understand and manage their expenses
- Receive AI-powered career guidance
- Build consistency through analytics
- Access core features even **without internet**

---

## ✨ Key Features

### 🧠 AI Career Guidance
- Personalized career advice using **Gemini AI**
- Context-aware responses based on student goals
- Graceful fallback when AI service is unavailable

### 🗓️ Study Planner
- Add, track, and manage study tasks
- Offline-first using **SQLite**
- Automatic sync with Firestore when online

### 💸 Finance Tracker
- Track daily expenses
- Weekly spending insights
- Fully usable offline with cloud sync

### 📊 Analytics Dashboard
- Weekly **study streaks** (behavior-based analytics)
- Weekly expense summaries
- Pull-to-refresh support

### 🌙 Premium UI/UX
- Clean, modern design
- Dark / Light mode support
- Bottom navigation for smooth user experience

### 🔐 Authentication & Profile
- Secure email/password authentication (Firebase Auth)
- One-time profile setup
- Editable profile section
- Logout support

---

## 🧩 Offline-First Architecture

PathPilot is designed to work reliably in low-connectivity environments:

- 📦 SQLite for local storage
- ☁️ Firebase Firestore for cloud sync
- 🔄 Automatic sync when connectivity is restored

---

## ⚙️ Tech Stack

| Layer | Technology |
|------|-----------|
| Frontend | Flutter |
| Authentication | Firebase Auth |
| Cloud Database | Firebase Firestore |
| Local Database | SQLite |
| AI | Gemini AI APIs |
| Architecture | Repository + Services |
| Theme | Dark / Light Mode |
| Platforms | Android, iOS, Web |

---

## 🏗️ Project Structure (Simplified)

lib/
├── local_db/ # SQLite database
├── models/ # Data models
├── repositories/ # Business logic & analytics
├── services/ # Auth, AI, sync services
├── screens/ # UI screens
├── widgets/ # Reusable UI components
├── theme/ # App theming
└── main.dart

## 🧪 How to Run Locally

```bash
flutter pub get
flutter run
⚠️ Firebase configuration files are excluded for security reasons.

🏆 Hackathon Project
- This project was built as part of a student innovation hackathon, focusing on:

- Solving real-world student problems

- Practical usability

- Clean and scalable architecture

- Offline reliability

🚀 Future Enhancements
- Skill-based career roadmaps

- Push notifications & reminders

- Expense categorization with charts

- Mentor / counselor integration

- Web dashboard for institutions

👨‍💻 Author
- Mahesh Lute
- GitHub: https://github.com/mahi-codes-dev

📜 License
- This project is created for educational and hackathon purposes.