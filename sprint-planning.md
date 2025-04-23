## Sprint Planning Document for "UpdateMe" App

### Step 1: Identify Main Features
Based on the product spec, the main features of the "Updates" app include:
- Home Tab: Quick and Custom Updates, Partner Status
- Schedule Tab: Auto-Scheduled Updates, Personal Schedule
- Activity Tab: Partner’s Updates Feed
- Settings Tab: Privacy, Notifications, Partner Info, etc.
- Local Data Persistence using `UserDefaults`
- Image and Audio Support for Updates

### Step 2: Breakdown into Sprints
Since there are only two weeks to complete development, the features have been grouped into two sprints.

#### Sprint 1: Project Setup & Home + Partner Tab
- Set up Xcode project using UIKit and Storyboard
- Implement Tab Bar with all 4 tabs: Home, Schedule, Activity, Settings
- Create basic layout for Home tab
- Implement Quick Update buttons (preset status)
- Implement Custom Update form with message, note, image, audio, and until date
- Save updates using `UserDefaults`
- Partner profile view with status dot and navigation to partner detail view
- Partner detail view shows most recent and next scheduled update
- Used `UserDefaults` and mock JSON data for partner updates

#### Sprint 2: Schedule, Activity, and Settings Tabs
- Implement Auto-Scheduled Updates screen
- Create auto-schedule form with message, note, frequency, time, etc.
- Enable editing, toggling, and deleting auto-schedules
- Implement Personal Schedule with title, description, status, start/end date, and visibility
- Implement Activity tab using fake data to display updates from partner
- Display full update details including message, date, note, image, and audio
- Build Settings tab with all listed features such as time zone, partner info, location toggle, backup/restore, dark mode, etc.

### Step 3: Weekly Goals

#### Week 1 Goal:
- Complete Sprint 1: App scaffold, Home tab functionality, and Partner Profile navigation

#### Week 2 Goal:
- Complete Sprint 2: Schedule, Activity, and Settings tab features
- Connect features using JSON or fake/mock data where applicable

### Step 4: GitHub Management
- Each sprint is developed in its own branch (e.g., `sprint-1-home`, `sprint-2-schedule`)
- Branches merged into `main` after each sprint is complete
- Used GitHub Issues to track to-dos and progress

### Step 5: Progress Update (Week 9 Submission)
Progress completed within the two-week development window:
- Project set up with all 4 main tabs
- Home tab functional with custom and quick updates saved to `UserDefaults`
- Partner status view navigates to detail screen
- Schedule and Activity tab layouts implemented
- Used mock JSON and fake data where real backend or services were unavailable
- Settings tab implemented with core features
- Video demo recorded and submitted

Sprints 1 and 2 are both complete. All features have been developed using local storage and mock data to simulate real-time behavior.

