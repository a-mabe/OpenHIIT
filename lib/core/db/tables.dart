const String workoutTableName = "WorkoutTable";
const String intervalTableName = "IntervalTable";
const String timerTableName = "TimerTable";
const String timeSettingsTableName = "TimeSettingsTable";
const String soundSettingsTableName = "SoundSettingsTable";

const createWorkoutTableQuery = '''
      CREATE TABLE IF NOT EXISTS $workoutTableName(
        id TEXT PRIMARY KEY,
        title TEXT,
        numExercises INTEGER,
        exercises TEXT,
        getReadyTime INTEGER,
        exerciseTime INTEGER,
        restTime INTEGER,
        halfTime INTEGER,
        breakTime INTEGER,
        warmupTime INTEGER,
        cooldownTime INTEGER,
        iterations INTEGER,
        halfwayMark INTEGER,
        workSound TEXT,
        restSound TEXT,
        halfwaySound TEXT,
        completeSound TEXT,
        countdownSound TEXT,
        colorInt INTEGER,
        workoutIndex INTEGER,
        showMinutes INTEGER
      )
    ''';

const createIntervalTableQuery = '''
      CREATE TABLE IF NOT EXISTS $intervalTableName(
        id TEXT PRIMARY KEY,
        workoutId TEXT,
        time INTEGER,
        name TEXT,
        color INTEGER,
        intervalIndex INTEGER,
        startSound TEXT,
        halfwaySound TEXT,
        countdownSound TEXT,
        endSound TEXT
      )
    ''';

const createTimerTableQuery = '''
      CREATE TABLE IF NOT EXISTS $timerTableName(
        id TEXT PRIMARY KEY,
        name TEXT,
        timerIndex INTEGER,
        totalTime INTEGER,
        intervals INTEGER,
        activeIntervals INTEGER,
        restarts INTEGER,
        activities TEXT,
        showMinutes INTEGER,
        color INTEGER
      )
    ''';

const createTimeSettingsTableQuery = '''
      CREATE TABLE IF NOT EXISTS $timeSettingsTableName(
        id TEXT PRIMARY KEY,
        timerId TEXT,
        getReadyTime INTEGER,
        workTime INTEGER,
        restTime INTEGER,
        breakTime INTEGER,
        warmupTime INTEGER,
        cooldownTime INTEGER
      )
    ''';

const createSoundSettingsTableQuery = '''
      CREATE TABLE IF NOT EXISTS $soundSettingsTableName(
        id TEXT PRIMARY KEY,
        timerId TEXT,
        workSound TEXT,
        restSound TEXT,
        halfwaySound TEXT,
        endSound TEXT,
        countdownSound TEXT
      )
    ''';
