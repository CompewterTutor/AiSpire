-- AiSpire UI Manager
-- Handles all UI elements for the AiSpire gadget
local ui = {}

-- Load required libraries
local socket = require("socket")

-- UI configuration
ui.CONFIG = {
    UI_VERSION = "0.1.0",
    MAX_LOG_ENTRIES = 1000,
    MAX_HISTORY_ENTRIES = 500,
    WINDOW_WIDTH = 800,
    WINDOW_HEIGHT = 600,
    LOG_HEIGHT = 200,
    REFRESH_INTERVAL = 0.5,  -- in seconds
    COLORS = {
        INFO = "#000000",
        WARNING = "#FFA500",
        ERROR = "#FF0000",
        SUCCESS = "#008000",
        DEBUG = "#808080",
        HEADER = "#0066CC"
    }
}

-- Private variables
local logEntries = {}
local commandHistory = {}
local isDialogOpen = false
local dialogInstance = nil
local lastUIUpdate = 0
local connectionStatus = "disconnected"
local isExecutingCommand = false
local currentCommandStartTime = nil
local serverReference = nil

-- ===================================
-- Log Management
-- ===================================

-- Add a log entry
function ui.log(level, message)
    local entry = {
        timestamp = os.time(),
        level = level or "INFO",
        message = message or "",
        formatted = os.date("%H:%M:%S", os.time()) .. " [" .. (level or "INFO") .. "] " .. (message or "")
    }
    
    table.insert(logEntries, 1, entry)
    
    -- Keep the log at a manageable size
    if #logEntries > ui.CONFIG.MAX_LOG_ENTRIES then
        table.remove(logEntries)
    end
    
    -- Update the UI if it's open
    if isDialogOpen and os.time() - lastUIUpdate >= ui.CONFIG.REFRESH_INTERVAL then
        ui.updateLogView()
        lastUIUpdate = os.time()
    end
    
    return true
end

-- Clear the log
function ui.clearLog()
    logEntries = {}
    return true
end

-- Save the log to a file
function ui.saveLog(filename)
    local file = io.open(filename, "w")
    if not file then
        ui.log("ERROR", "Failed to open log file for writing: " .. filename)
        return false
    end
    
    file:write("--- AiSpire Log ---\n")
    file:write("Generated: " .. os.date("%Y-%m-%d %H:%M:%S") .. "\n\n")
    
    for i = #logEntries, 1, -1 do
        file:write(logEntries[i].formatted .. "\n")
    end
    
    file:close()
    ui.log("INFO", "Log saved to: " .. filename)
    return true
end

-- ===================================
-- Command History Management
-- ===================================

-- Add a command to history
function ui.addCommandToHistory(command, response)
    local entry = {
        timestamp = os.time(),
        command = command,
        response = response,
        formatted = os.date("%H:%M:%S", os.time()) .. " - " .. (command.command_type or "unknown")
    }
    
    table.insert(commandHistory, 1, entry)
    
    -- Keep the history at a manageable size
    if #commandHistory > ui.CONFIG.MAX_HISTORY_ENTRIES then
        table.remove(commandHistory)
    end
    
    -- Update the UI if it's open
    if isDialogOpen and os.time() - lastUIUpdate >= ui.CONFIG.REFRESH_INTERVAL then
        ui.updateHistoryView()
        lastUIUpdate = os.time()
    end
    
    return true
end

-- Clear the command history
function ui.clearHistory()
    commandHistory = {}
    return true
end

-- Save the command history to a file
function ui.saveHistory(filename)
    local file = io.open(filename, "w")
    if not file then
        ui.log("ERROR", "Failed to open history file for writing: " .. filename)
        return false
    end
    
    file:write("--- AiSpire Command History ---\n")
    file:write("Generated: " .. os.date("%Y-%m-%d %H:%M:%S") .. "\n\n")
    
    -- Save as JSON for easy replay
    local json = require("json")
    local saveHistory = {}
    
    for i = #commandHistory, 1, -1 do
        local command = commandHistory[i].command
        if command then
            -- Remove authentication token before saving
            command.auth = nil
            table.insert(saveHistory, command)
        end
    end
    
    file:write(json.encode(saveHistory))
    file:close()
    ui.log("INFO", "Command history saved to: " .. filename)
    return true
end

-- Load command history from a file
function ui.loadHistory(filename)
    local file = io.open(filename, "r")
    if not file then
        ui.log("ERROR", "Failed to open history file for reading: " .. filename)
        return false
    end
    
    local contents = file:read("*all")
    file:close()
    
    if not contents or contents == "" then
        ui.log("ERROR", "History file is empty: " .. filename)
        return false
    end
    
    local json = require("json")
    local loadedHistory, err = json.decode(contents)
    
    if not loadedHistory then
        ui.log("ERROR", "Failed to parse history file: " .. (err or "unknown error"))
        return false
    end
    
    -- Clear current history and replace with loaded history
    ui.clearHistory()
    
    -- Process loaded commands
    for i, command in ipairs(loadedHistory) do
        ui.addCommandToHistory(command, nil)
    end
    
    ui.log("INFO", "Command history loaded from: " .. filename)
    return true
end

-- Execute a command from history
function ui.executeHistoryItem(index)
    if not serverReference then
        ui.log("ERROR", "Server reference not available")
        return false
    end
    
    local command = commandHistory[index] and commandHistory[index].command
    if not command then
        ui.log("ERROR", "Command not found at index: " .. index)
        return false
    end
    
    -- Add authentication token back
    command.auth = serverReference.CONFIG.AUTH_TOKEN
    
    -- Process the command
    ui.log("INFO", "Executing command from history: " .. (command.command_type or "unknown"))
    
    local commandStr = require("json").encode(command)
    local result = serverReference.processCommand(commandStr)
    
    -- Record the result
    ui.addCommandToHistory(command, result)
    
    return true
end

-- Replay all commands from history
function ui.replayAllHistory()
    if #commandHistory == 0 then
        ui.log("INFO", "No commands in history to replay")
        return true
    end
    
    ui.log("INFO", "Replaying all commands from history...")
    
    -- We need to replay from oldest to newest
    for i = #commandHistory, 1, -1 do
        ui.executeHistoryItem(i)
        -- Small delay to prevent overwhelming the system
        socket.sleep(0.1)
    end
    
    ui.log("INFO", "History replay complete")
    return true
end

-- ===================================
-- Connection Status Management
-- ===================================

-- Set the connection status
function ui.setConnectionStatus(status, details)
    connectionStatus = status or "disconnected"
    
    if status == "connected" then
        ui.log("INFO", "Connected to MCP server: " .. (details or ""))
    elseif status == "disconnected" then
        ui.log("INFO", "Disconnected from MCP server: " .. (details or ""))
    elseif status == "error" then
        ui.log("ERROR", "Connection error: " .. (details or "unknown error"))
    end
    
    -- Update the UI if it's open
    if isDialogOpen then
        ui.updateConnectionStatus()
    end
    
    return true
end

-- Start command execution
function ui.startCommandExecution()
    isExecutingCommand = true
    currentCommandStartTime = os.time()
    
    -- Update the UI if it's open
    if isDialogOpen then
        ui.updateConnectionStatus()
    end
    
    return true
end

-- End command execution
function ui.endCommandExecution()
    isExecutingCommand = false
    currentCommandStartTime = nil
    
    -- Update the UI if it's open
    if isDialogOpen then
        ui.updateConnectionStatus()
    end
    
    return true
end

-- ===================================
-- UI Creation and Management
-- ===================================

-- Create the main HTML for the UI dialog
function ui.createMainDialogHtml()
    local html = [[
<!DOCTYPE html>
<html>
<head>
    <title>AiSpire Control Panel</title>
    <style type="text/css">
        html, body {
            font-family: Arial, Helvetica, sans-serif;
            font-size: 12px;
            margin: 0;
            padding: 0;
            width: 100%;
            height: 100%;
            overflow: hidden;
            background-color: #f0f0f0;
        }
        .container {
            display: flex;
            flex-direction: column;
            height: 100%;
        }
        .header {
            padding: 10px;
            background-color: #0066CC;
            color: white;
            font-weight: bold;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }
        .header-title {
            font-size: 16px;
        }
        .content {
            flex: 1;
            display: flex;
            flex-direction: column;
            padding: 10px;
            overflow: hidden;
        }
        .tab-container {
            flex: 1;
            display: flex;
            flex-direction: column;
        }
        .tab-buttons {
            display: flex;
            margin-bottom: 5px;
        }
        .tab-button {
            padding: 5px 15px;
            margin-right: 5px;
            border: 1px solid #ccc;
            background-color: #f0f0f0;
            cursor: pointer;
        }
        .tab-button.active {
            background-color: #0066CC;
            color: white;
            border-color: #0066CC;
        }
        .tab-content {
            flex: 1;
            border: 1px solid #ccc;
            background-color: white;
            display: flex;
            flex-direction: column;
            overflow: hidden;
        }
        .tab-panel {
            flex: 1;
            overflow: auto;
            display: none;
            padding: 10px;
        }
        .tab-panel.active {
            display: block;
        }
        .log-entry {
            margin-bottom: 2px;
            font-family: monospace;
            white-space: pre-wrap;
            word-wrap: break-word;
        }
        .history-entry {
            margin-bottom: 5px;
            padding: 5px;
            border: 1px solid #ddd;
            background-color: #f9f9f9;
            cursor: pointer;
        }
        .history-entry:hover {
            background-color: #e9e9e9;
        }
        .history-entry.success {
            border-left: 4px solid green;
        }
        .history-entry.error {
            border-left: 4px solid red;
        }
        .status-bar {
            padding: 5px 10px;
            background-color: #e0e0e0;
            border-top: 1px solid #ccc;
            display: flex;
            justify-content: space-between;
        }
        .status-indicator {
            display: flex;
            align-items: center;
        }
        .status-dot {
            width: 10px;
            height: 10px;
            border-radius: 50%;
            margin-right: 5px;
        }
        .status-dot.connected {
            background-color: green;
        }
        .status-dot.disconnected {
            background-color: red;
        }
        .status-dot.busy {
            background-color: orange;
        }
        .button-container {
            margin-top: 10px;
            display: flex;
            justify-content: space-between;
        }
        .action-button {
            padding: 5px 15px;
            margin-right: 5px;
            background-color: #0066CC;
            color: white;
            border: none;
            cursor: pointer;
        }
        .action-button.danger {
            background-color: #cc3300;
        }
        .action-button.secondary {
            background-color: #666;
        }
        .alert {
            position: fixed;
            top: 50%;
            left: 50%;
            transform: translate(-50%, -50%);
            padding: 20px;
            background-color: white;
            border: 2px solid #cc3300;
            box-shadow: 0 0 10px rgba(0,0,0,0.5);
            z-index: 1000;
            display: none;
        }
        .alert.visible {
            display: block;
        }
        .alert-buttons {
            margin-top: 15px;
            text-align: right;
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="header">
            <div class="header-title">AiSpire Control Panel</div>
            <div id="version">v]] .. ui.CONFIG.UI_VERSION .. [[</div>
        </div>
        <div class="content">
            <div class="tab-container">
                <div class="tab-buttons">
                    <div id="tab-btn-log" class="tab-button active" onclick="switchTab('log')">Log View</div>
                    <div id="tab-btn-history" class="tab-button" onclick="switchTab('history')">Command History</div>
                </div>
                <div class="tab-content">
                    <div id="tab-log" class="tab-panel active">
                        <div id="log-entries"></div>
                    </div>
                    <div id="tab-history" class="tab-panel">
                        <div id="history-entries"></div>
                    </div>
                </div>
                <div class="button-container">
                    <!-- Log Tab Buttons -->
                    <div id="log-buttons">
                        <button id="btn-clear-log" class="action-button secondary" onclick="clearLog()">Clear Log</button>
                        <button id="btn-save-log" class="action-button" onclick="saveLog()">Save Log</button>
                    </div>
                    <!-- History Tab Buttons -->
                    <div id="history-buttons" style="display: none;">
                        <button id="btn-clear-history" class="action-button secondary" onclick="clearHistory()">Clear History</button>
                        <button id="btn-save-history" class="action-button" onclick="saveHistory()">Save History</button>
                        <button id="btn-load-history" class="action-button" onclick="loadHistory()">Load History</button>
                        <button id="btn-replay-history" class="action-button" onclick="replayHistory()">Replay All</button>
                    </div>
                </div>
            </div>
        </div>
        <div class="status-bar">
            <div class="status-indicator">
                <div id="status-dot" class="status-dot disconnected"></div>
                <div id="status-text">Disconnected</div>
            </div>
            <button id="btn-disconnect" class="action-button danger" onclick="confirmDisconnect()">Disconnect</button>
        </div>
    </div>
    
    <!-- Alert Dialog -->
    <div id="alert-dialog" class="alert">
        <div id="alert-message">Are you sure you want to disconnect?</div>
        <div class="alert-buttons">
            <button id="alert-cancel" class="action-button secondary" onclick="hideAlert()">Cancel</button>
            <button id="alert-confirm" class="action-button danger" onclick="disconnect()">Disconnect</button>
        </div>
    </div>

    <script>
        function switchTab(tabId) {
            // Hide all tab panels
            var tabPanels = document.getElementsByClassName('tab-panel');
            for (var i = 0; i < tabPanels.length; i++) {
                tabPanels[i].classList.remove('active');
            }
            
            // Deactivate all tab buttons
            var tabButtons = document.getElementsByClassName('tab-button');
            for (var i = 0; i < tabButtons.length; i++) {
                tabButtons[i].classList.remove('active');
            }
            
            // Show the selected tab panel
            document.getElementById('tab-' + tabId).classList.add('active');
            
            // Activate the selected tab button
            document.getElementById('tab-btn-' + tabId).classList.add('active');
            
            // Show relevant buttons
            document.getElementById('log-buttons').style.display = tabId === 'log' ? 'block' : 'none';
            document.getElementById('history-buttons').style.display = tabId === 'history' ? 'block' : 'none';
        }
        
        function confirmDisconnect() {
            document.getElementById('alert-dialog').classList.add('visible');
        }
        
        function hideAlert() {
            document.getElementById('alert-dialog').classList.remove('visible');
        }
        
        function disconnect() {
            hideAlert();
            ButtonDisconnect();
        }
        
        function clearLog() {
            ButtonClearLog();
        }
        
        function saveLog() {
            ButtonSaveLog();
        }
        
        function clearHistory() {
            ButtonClearHistory();
        }
        
        function saveHistory() {
            ButtonSaveHistory();
        }
        
        function loadHistory() {
            ButtonLoadHistory();
        }
        
        function replayHistory() {
            ButtonReplayHistory();
        }
        
        function executeHistoryItem(index) {
            ButtonExecuteHistoryItem(index);
        }
    </script>
</body>
</html>
    ]]
    
    return html
end

-- Update the log view in the UI
function ui.updateLogView()
    if not dialogInstance then return false end
    
    local logHtml = ""
    for i, entry in ipairs(logEntries) do
        local color = ui.CONFIG.COLORS[entry.level] or ui.CONFIG.COLORS.INFO
        logHtml = logHtml .. '<div class="log-entry" style="color: ' .. color .. '">' .. entry.formatted .. '</div>'
    end
    
    dialogInstance:SetFieldHTML("log-entries", logHtml)
    return true
end

-- Update the history view in the UI
function ui.updateHistoryView()
    if not dialogInstance then return false end
    
    local historyHtml = ""
    for i, entry in ipairs(commandHistory) do
        local status = entry.response and entry.response.status or ""
        local statusClass = status == "success" and "success" or (status == "error" and "error" or "")
        
        historyHtml = historyHtml .. '<div class="history-entry ' .. statusClass .. '" onclick="executeHistoryItem(' .. i .. ')">'
        historyHtml = historyHtml .. '<div>' .. entry.formatted .. '</div>'
        
        if entry.command and entry.command.command_type then
            historyHtml = historyHtml .. '<div><small>Type: ' .. entry.command.command_type .. '</small></div>'
        end
        
        if entry.response then
            local message = entry.response.result and entry.response.result.message or ""
            historyHtml = historyHtml .. '<div><small>Result: ' .. message .. '</small></div>'
        end
        
        historyHtml = historyHtml .. '</div>'
    end
    
    dialogInstance:SetFieldHTML("history-entries", historyHtml)
    return true
end

-- Update the connection status in the UI
function ui.updateConnectionStatus()
    if not dialogInstance then return false end
    
    local statusDotClass = "disconnected"
    local statusText = "Disconnected"
    
    if connectionStatus == "connected" then
        if isExecutingCommand then
            statusDotClass = "busy"
            local elapsedTime = os.time() - (currentCommandStartTime or os.time())
            statusText = "Executing command (" .. elapsedTime .. "s)"
        else
            statusDotClass = "connected"
            statusText = "Connected"
        end
    elseif connectionStatus == "error" then
        statusDotClass = "disconnected"
        statusText = "Connection Error"
    end
    
    dialogInstance:SetFieldAttribute("status-dot", "class", "status-dot " .. statusDotClass)
    dialogInstance:SetFieldHTML("status-text", statusText)
    return true
end

-- Show a file dialog and return the selected file path
function ui.showFileDialog(title, forSave, defaultPath, filter)
    local fileDialog = FileDialog()
    local path
    
    if forSave then
        path = fileDialog:ShowSaveDialog(title or "Save File", filter or "*.*", defaultPath or "")
    else
        path = fileDialog:ShowOpenDialog(title or "Open File", filter or "*.*", defaultPath or "")
    end
    
    return path
end

-- Show a confirmation dialog
function ui.showConfirmationDialog(title, message, onConfirm)
    local html = [[
<!DOCTYPE html>
<html>
<head>
    <title>]] .. (title or "Confirm") .. [[</title>
    <style type="text/css">
        html, body {
            font-family: Arial, Helvetica, sans-serif;
            font-size: 12px;
            margin: 0;
            padding: 10px;
            background-color: #f0f0f0;
        }
        .message {
            margin-bottom: 20px;
        }
        .buttons {
            text-align: right;
        }
        .button {
            padding: 5px 15px;
            margin-left: 10px;
            cursor: pointer;
        }
        .button-ok {
            background-color: #0066CC;
            color: white;
            border: none;
        }
        .button-cancel {
            background-color: #e0e0e0;
            border: 1px solid #ccc;
        }
    </style>
</head>
<body>
    <div class="message">]] .. (message or "") .. [[</div>
    <div class="buttons">
        <button id="btn-cancel" class="button button-cancel" onclick="ButtonCancel()">Cancel</button>
        <button id="btn-ok" class="button button-ok" onclick="ButtonOK()">OK</button>
    </div>
</body>
</html>
    ]]
    
    local dialog = HTML_Dialog(true, html, 400, 200, title or "Confirm")
    local result = dialog:ShowDialog()
    
    if result and onConfirm then
        onConfirm()
    end
    
    return result
end

-- Button callback functions
function ui.ButtonClearLog()
    ui.clearLog()
    ui.updateLogView()
end

function ui.ButtonSaveLog()
    local path = ui.showFileDialog("Save Log File", true, nil, "*.log")
    if path then
        ui.saveLog(path)
    end
end

function ui.ButtonClearHistory()
    ui.showConfirmationDialog(
        "Clear History", 
        "Are you sure you want to clear the command history?",
        function() 
            ui.clearHistory()
            ui.updateHistoryView()
        end
    )
end

function ui.ButtonSaveHistory()
    local path = ui.showFileDialog("Save History File", true, nil, "*.json")
    if path then
        ui.saveHistory(path)
    end
end

function ui.ButtonLoadHistory()
    local path = ui.showFileDialog("Load History File", false, nil, "*.json")
    if path then
        if ui.loadHistory(path) then
            ui.updateHistoryView()
        end
    end
end

function ui.ButtonReplayHistory()
    ui.showConfirmationDialog(
        "Replay History", 
        "Are you sure you want to replay all commands in history?",
        function() 
            ui.replayAllHistory()
        end
    )
end

function ui.ButtonExecuteHistoryItem(index)
    ui.executeHistoryItem(index)
end

function ui.ButtonDisconnect()
    if serverReference then
        serverReference.stopServer()
        ui.setConnectionStatus("disconnected", "User initiated disconnect")
    end
end

-- Dialog button handlers
function ui.DialogButtonClearLog()
    ui.clearLog()
    ui.updateLogView()
    return true
end

function ui.DialogButtonSaveLog()
    local path = ui.showFileDialog("Save Log File", true, nil, "*.log")
    if path then
        ui.saveLog(path)
    end
    return true
end

function ui.DialogButtonClearHistory()
    ui.clearHistory()
    ui.updateHistoryView()
    return true
end

function ui.DialogButtonSaveHistory()
    local path = ui.showFileDialog("Save History File", true, nil, "*.json")
    if path then
        ui.saveHistory(path)
    end
    return true
end

function ui.DialogButtonLoadHistory()
    local path = ui.showFileDialog("Load History File", false, nil, "*.json")
    if path then
        if ui.loadHistory(path) then
            ui.updateHistoryView()
        end
    end
    return true
end

function ui.DialogButtonReplayHistory()
    ui.replayAllHistory()
    return true
end

function ui.DialogButtonExecuteHistoryItem(index)
    ui.executeHistoryItem(index)
    return true
end

function ui.DialogButtonDisconnect()
    ui.ButtonDisconnect()
    return true
end

-- Show the UI dialog
function ui.showDialog()
    if isDialogOpen then
        -- Already open, just bring to front
        return true
    end
    
    local html = ui.createMainDialogHtml()
    dialogInstance = HTML_Dialog(true, html, ui.CONFIG.WINDOW_WIDTH, ui.CONFIG.WINDOW_HEIGHT, "AiSpire Control Panel")
    
    -- Dialog event handling
    dialogInstance:SetOnButtonCallback("ButtonClearLog", ui.DialogButtonClearLog)
    dialogInstance:SetOnButtonCallback("ButtonSaveLog", ui.DialogButtonSaveLog)
    dialogInstance:SetOnButtonCallback("ButtonClearHistory", ui.DialogButtonClearHistory)
    dialogInstance:SetOnButtonCallback("ButtonSaveHistory", ui.DialogButtonSaveHistory)
    dialogInstance:SetOnButtonCallback("ButtonLoadHistory", ui.DialogButtonLoadHistory)
    dialogInstance:SetOnButtonCallback("ButtonReplayHistory", ui.DialogButtonReplayHistory)
    dialogInstance:SetOnButtonCallback("ButtonExecuteHistoryItem", ui.DialogButtonExecuteHistoryItem)
    dialogInstance:SetOnButtonCallback("ButtonDisconnect", ui.DialogButtonDisconnect)
    
    -- Update the initial UI state
    ui.updateLogView()
    ui.updateHistoryView()
    ui.updateConnectionStatus()
    
    -- Show the dialog
    isDialogOpen = true
    dialogInstance:ShowDialog()
    
    -- Dialog closed
    isDialogOpen = false
    dialogInstance = nil
    
    return true
end

-- Initialize UI
function ui.initialize(server)
    serverReference = server
    ui.log("INFO", "UI Manager initialized")
    return true
end

-- Return the module
return ui