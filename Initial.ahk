; ====================================================
;      DAILY TASK AUTOMATION SYSTEM
; ====================================================

#SingleInstance Force
#NoEnv
SendMode Input
SetWorkingDir %A_ScriptDir%

; 
Global TaskLogFile := "task_log.txt"
Global ScheduledTasks := {}
Global NextTaskId := 1

; 
Init() {
    FileAppend, --- Daily Task Automation Log Started at %A_Now% ---`n, %TaskLogFile%
    CreateScheduledTask("Check Email", "RunNotepad", 9, 0)  ; Пример: проверка почты в 9:00
    CreateScheduledTask("Backup Files", "BackupDocuments", 17, 30) ; Пример: бэкап в 17:30
}

; 
Init()

; 
ShowGUI() {
    Gui, Destroy
    Gui, Add, Text, x10 y10 w200 h20, Daily Task Automation System
    Gui, Add, Button, x10 y40 w120 h30 gAddTask, Add New Task
    Gui, Add, Button, x140 y40 w120 h30 gViewTasks, View Scheduled Tasks
    Gui, Add, Button, x10 y80 w120 h30 gRunNow, Run Task Now
    Gui, Add, Button, x140 y80 w120 h30 gShowLog, View Log
    Gui, Add, Button, x10 y120 w250 h30 gExitApp, Exit
    Gui, Show, w270 h160, Task Automation
}

; 
AddTask() {
    Gui, New
    Gui, Add, Text, x10 y10 w200 h20, Task Name:
    Gui, Add, Edit, x10 y35 w200 h20 vTaskName
    Gui, Add, Text, x10 y60 w200 h20, Action (function name):
    Gui, Add, Edit, x10 y85 w200 h20 vTaskAction
    Gui, Add, Text, x10 y110 w50 h20, Hour:
    Gui, Edit, x60 y110 w40 h20 vTaskHour
    Gui, Add, Text, x110 y110 w50 h20, Minute:
    Gui, Edit, x160 y110 w40 h20 vTaskMinute
    Gui, Add, Button, x10 y140 w200 h30 gSaveTask, Save Task
    Gui, Show, w220 h180, Add New Task
}

SaveTask() {
    Gui, Submit
    if (TaskName = "" || TaskAction = "" || TaskHour = "" || TaskMinute = "") {
        MsgBox, Please fill all fields!
        return
    }
    if (!IsNumber(TaskHour) || !IsNumber(TaskMinute) || TaskHour < 0 || TaskHour > 23 || TaskMinute < 0 || TaskMinute > 59) {
        MsgBox, Invalid time format!
        return
    }
    CreateScheduledTask(TaskName, TaskAction, TaskHour, TaskMinute)
    MsgBox, Task added successfully!
    Gui, Destroy
}

; 
CreateScheduledTask(Name, Action, Hour, Minute) {
    global ScheduledTasks, NextTaskId
    ScheduledTasks[NextTaskId] := {Name: Name, Action: Action, Hour: Hour, Minute: Minute, Active: true}
    LogEvent("Task created: " . Name . " at " . Hour . ":" . Minute)
    NextTaskId++
}

; 
ViewTasks() {
    if (ScheduledTasks.Length() = 0) {
        MsgBox, No scheduled tasks found.
        return
    }
    Output := "Scheduled Tasks:`n`n"
    for Id, Task in ScheduledTasks {
        Output .= Id . ". " . Task.Name . " at " . Task.Hour . ":" . Task.Minute . "`n"
    }
    MsgBox, %Output%
}
