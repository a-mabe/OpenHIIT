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
| `integration_test/simple_test.dart`   | Covers basic timer creation, i.e. minimum viable functionality. |
| `integration_test/advanced_test.dart`    | Runs a timer with all time settings changed. |
| `integration_test/load_test.dart`  | Tests initial app load with no timers saved. |
| `integration_test/edit_timer_test.dart` | Ensures a basic timer can be edited and those edits are saved. |
| `integration_test/interval_adjust_test.dart` | Tests that the active intervals fields can be set and edited. |
| `integration_test/restart_rounds_test.dart` | Tests the restart and break time functionality. |
| `integration_test/customize_test.dart` | Tests timer name and color input fields. Actual color change needs verified in QA. |
| `integration_test/minutes_view_test.dart` | Tests timer can be set to minutes view. |