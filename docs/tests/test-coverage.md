# ✅ Test Coverage

This document outlines current test coverage for core timer functionality, with a focus on creation, editing, and execution behaviors.

---

## 🧪 Test Case Coverage

### 🗂️ Legend

| Symbol | Meaning               |
|--------|------------------------|
| ✅     | Covered by automated integration tests |
| 👤     | Verified via manual QA     |

| Test Case | Tested? | Notes |
|---|---|---|
| App loads and shows "No saved timers" | ✅ | Ensures initial database setup |
| Create a timer with only required settings | ✅ | Ensures minimal viable timer creation works |
| Create a timer with all possible settings configured | ✅ | Verifies full set of configurable fields saves correctly |
| Edit time values of an existing timer (e.g., work/rest duration) | ✅ | Confirms edits are persisted and reflected in UI |
| Decrease the number of work/rest intervals | ✅ | Verifies that timer shortens correctly |
| Increase the number of work/rest intervals | ✅ | Validates timer adds intervals as expected |
| Remove all restart rounds from a timer | ✅ | Verifies correct removal and UI update |
| Add restart rounds to a timer | ✅ | Confirms timer reflects added restarts |
| Save a timer without any break period configured | ✅ | Validates default/fallback behavior |
| Save a timer with a break period configured | ✅ | Confirms timer uses break settings |
| Rename an existing timer and save | ✅ | Confirms rename updates both list and detail views |
| Switch timer display from seconds to minutes | ✅ | Verifies config persistence and runtime logic |
| Change the timer's color label | 👤 | Cosmetic change — UI update verified manually |
| Test that timer plays correct sound effects | 👤 | Requires manual confirmation that sounds play correctly at each phase |
| Import a timer from external file | 👤 | Requires manual test to verify timer is parsed and added correctly |
| Export a timer via share and save to device | 👤 | Requires manual test to verify file is shared and stored successfully |

---

## 📁 Test File Overview

| File Name                    | Description                                        |
|------------------------------|----------------------------------------------------|
| `test/simple_timer_test.dart`   | Covers basic timer creation, i.e. minimum viable functionality |
| `test/advanced_timer_test.dart`    | Focuses on all possible settings and editing existing timers |
| `test/display_timer_test.dart`  | Focuses on the less funcitonal stuff, like UI and display related settings |
