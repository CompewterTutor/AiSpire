Global = {}

-- Global - method
-- Returns true if the script is running inside Aspire.
function Global.IsAspire() end

-- Global - method
-- Returns true if this is a Beta build rather than a release build.
function Global.IsBetaBuild() end

-- Global - method
-- Returns application version number as a double, e.g., 4.004 for Aspire V4.0.
function Global.GetAppVersion() end

-- Global - method
-- Returns application internal build version.
function Global.GetBuildVersion() end

-- Global - method
-- Displays a message box with passed text to the user.
function Global.MessageBox(text) end


VectricJob = {}

-- VectricJob - method
function VectricJob.ClearClipboard() end

-- VectricJob - method
function VectricJob.CopyToClipboard(text) end

-- VectricJob - method
function VectricJob.CreateHorizontalGuide(y_value, locked) end

-- VectricJob - method
function VectricJob.CreateVerticalGuide(x_value, locked) end

-- VectricJob - method
function VectricJob.DisplayToolpathPreviewForm() end

-- VectricJob - method
function VectricJob.ExportSelectionToEps(pathname) end

-- VectricJob - method
function VectricJob.ExportSelectionToDxf(pathname) end

-- VectricJob - method
function VectricJob.ExportSelectionToSvg(pathname) end

-- VectricJob - method
function VectricJob.ExportDocumentVariables(pathname) end

-- VectricJob - property
VectricJob.Exists = nil


MaterialBlock = {}

-- MaterialBlock - method
function MaterialBlock:GetWidth() end

-- MaterialBlock - method
function MaterialBlock:GetHeight() end

-- MaterialBlock - method
function MaterialBlock:GetThickness() end

-- MaterialBlock - method
function MaterialBlock:SetWidth(width) end

-- MaterialBlock - method
function MaterialBlock:SetHeight(height) end

-- MaterialBlock - method
function MaterialBlock:SetThickness(thickness) end

-- MaterialBlock - method
function MaterialBlock:Update() end

-- MaterialBlock - method
function MaterialBlock:IsDoubleSided() end


ToolpathManager = {}

-- ToolpathManager - method
function ToolpathManager:GetToolpathNames() end

-- ToolpathManager - method
function ToolpathManager:ToolpathExists(name) end

-- ToolpathManager - method
function ToolpathManager:GetToolpathByName(name) end

-- ToolpathManager - method
function ToolpathManager:DeleteToolpathByName(name) end

-- ToolpathManager - method
function ToolpathManager:RecalculateAllToolpaths() end

-- ToolpathManager - method
function ToolpathManager:SaveToolpathsToFile(filepath) end


LayerManager = {}

-- LayerManager - method
function LayerManager:GetNumLayers() end

-- LayerManager - method
function LayerManager:GetLayerName(index) end

-- LayerManager - method
function LayerManager:FindLayer(name) end

-- LayerManager - method
function LayerManager:AddNewLayer(name, color, is_visible, is_active) end

-- LayerManager - method
function LayerManager:SetLayerVisibility(name, is_visible) end

-- LayerManager - method
function LayerManager:SetActiveLayer(name) end


Tool = {}

-- Tool - method
function Tool:GetToolDiameter() end

-- Tool - method
function Tool:GetToolStepover() end

-- Tool - method
function Tool:GetToolFeedRate() end

-- Tool - method
function Tool:GetToolPlungeRate() end

-- Tool - method
function Tool:GetToolSpindleSpeed() end

-- Tool - method
function Tool:SetToolDiameter(value) end

-- Tool - method
function Tool:SetToolStepover(value) end

-- Tool - method
function Tool:SetToolFeedRate(value) end

-- Tool - method
function Tool:SetToolPlungeRate(value) end

-- Tool - method
function Tool:SetToolSpindleSpeed(value) end

Contour = {}

-- Contour - method
function Contour:AppendPoint(x, y) end

-- Contour - method
function Contour:AppendLineTo(x, y) end

-- Contour - method
function Contour:AppendArcTo(x, y, bulge) end

-- Contour - method
function Contour:AppendBezierTo(x, y, ctrl1_x, ctrl1_y, ctrl2_x, ctrl2_y) end

-- Contour - method
function Contour:IsClosed() end

-- Contour - method
function Contour:Close() end

-- Contour - method
function Contour:Reverse() end

-- Contour - method
function Contour:Clone() end

-- Contour - method
function Contour:GetStartPoint() end

-- Contour - method
function Contour:GetEndPoint() end

Arc = {}

-- Arc - method
function Arc:GetStartPoint() end

-- Arc - method
function Arc:GetEndPoint() end

-- Arc - method
function Arc:GetCentre() end

-- Arc - method
function Arc:GetRadius() end

-- Arc - method
function Arc:IsClockwise() end

Circle = {}

-- Circle - method
function Circle:GetCentre() end

-- Circle - method
function Circle:GetRadius() end

-- Circle - method
function Circle:SetCentre(x, y) end

-- Circle - method
function Circle:SetRadius(radius) end

Polyline = {}

-- Polyline - method
function Polyline:AppendPoint(x, y) end

-- Polyline - method
function Polyline:GetPoint(index) end

-- Polyline - method
function Polyline:GetNumPoints() end

-- Polyline - method
function Polyline:Reverse() end

-- Polyline - method
function Polyline:IsClosed() end

-- Polyline - method
function Polyline:Close() end

BezierCurve = {}

-- BezierCurve - method
function BezierCurve:GetStartPoint() end

-- BezierCurve - method
function BezierCurve:GetEndPoint() end

-- BezierCurve - method
function BezierCurve:GetControlPoint1() end

-- BezierCurve - method
function BezierCurve:GetControlPoint2() end

-- BezierCurve - method
function BezierCurve:SetStartPoint(x, y) end

-- BezierCurve - method
function BezierCurve:SetEndPoint(x, y) end

-- BezierCurve - method
function BezierCurve:SetControlPoint1(x, y) end

-- BezierCurve - method
function BezierCurve:SetControlPoint2(x, y) end

Selection = {}

-- Selection - method
function Selection:Clear() end

-- Selection - method
function Selection:Add(object) end

-- Selection - method
function Selection:Remove(object) end

-- Selection - method
function Selection:Contains(object) end

-- Selection - method
function Selection:GetHeadPosition() end

-- Selection - method
function Selection:GetNext(pos) end

-- Selection - method
function Selection:Count() end

Group = {}

-- Group - method
function Group:AddChild(object) end

-- Group - method
function Group:GetChild(index) end

-- Group - method
function Group:GetNumChildren() end

-- Group - method
function Group:Ungroup() end

Transformation2D = {}

-- Transformation2D - method
function Transformation2D:Translate(x, y) end

-- Transformation2D - method
function Transformation2D:Rotate(angle) end

-- Transformation2D - method
function Transformation2D:Scale(x_scale, y_scale) end

-- Transformation2D - method
function Transformation2D:ReflectX() end

-- Transformation2D - method
function Transformation2D:ReflectY() end

-- Transformation2D - method
function Transformation2D:ApplyToPoint(x, y) end

Job = {}

-- Job - method
function Job:GetJobWidth() end

-- Job - method
function Job:GetJobHeight() end

-- Job - method
function Job:GetMaterialBlock() end

-- Job - method
function Job:GetToolpathManager() end

-- Job - method
function Job:GetLayerManager() end

-- Job - method
function Job:GetSelection() end

-- Job - method
function Job:GetName() end

-- Job - method
function Job:GetPreviewBitmap() end

-- Job - method
function Job:GetDocumentVariables() end

-- Job - method
function Job:Save(pathname) end

-- Job - method
function Job:Export(pathname, format) end

Color = {}

-- Color - method
function Color:Red() end

-- Color - method
function Color:Green() end

-- Color - method
function Color:Blue() end

-- Color - method
function Color:Alpha() end

-- Color - method
function Color:SetRed(value) end

-- Color - method
function Color:SetGreen(value) end

-- Color - method
function Color:SetBlue(value) end

-- Color - method
function Color:SetAlpha(value) end

Text = {}

-- Text - method
function Text:SetFont(name, size, bold, italic) end

-- Text - method
function Text:SetText(string) end

-- Text - method
function Text:SetAlignment(alignment) end

-- Text - method
function Text:SetVerticalPosition(position) end

-- Text - method
function Text:SetOrientation(angle) end

-- Text - method
function Text:GetBoundingBox() end

-- Text - method
function Text:DrawAtPosition(x, y) end

Toolpath = {}

-- Toolpath - method
function Toolpath:SetName(name) end

-- Toolpath - method
function Toolpath:SetCutDepth(depth) end

-- Toolpath - method
function Toolpath:SetTool(tool) end

-- Toolpath - method
function Toolpath:SetPassDepth(pass_depth) end

-- Toolpath - method
function Toolpath:SetStepover(stepover) end

-- Toolpath - method
function Toolpath:SetRamp(ramp_length) end

-- Toolpath - method
function Toolpath:SetTabs(tab_data) end

-- Toolpath - method
function Toolpath:SetMaterialAllowance(allowance) end

-- Toolpath - method
function Toolpath:SetDirection(climb_cut) end

-- Toolpath - method
function Toolpath:Calculate() end

ToolpathPreview = {}

-- ToolpathPreview - method
function ToolpathPreview:ResetPreview() end

-- ToolpathPreview - method
function ToolpathPreview:PreviewToolpath(toolpath) end

-- ToolpathPreview - method
function ToolpathPreview:SimulateCutting() end

-- ToolpathPreview - method
function ToolpathPreview:ShowPreviewWindow() end

MessageBox = {}

-- MessageBox - method
function MessageBox:Show(title, text, buttons, icon) end

Dialog = {}

-- Dialog - method
function Dialog:AddTextField(id, label, default) end

-- Dialog - method
function Dialog:AddNumberField(id, label, default, min, max, decimals) end

-- Dialog - method
function Dialog:AddCheckBox(id, label, default) end

-- Dialog - method
function Dialog:AddDropDown(id, label, options, default_index) end

-- Dialog - method
function Dialog:Show(title) end

-- Dialog - method
function Dialog:GetValue(id) end

Point2D = {}

-- Point2D - method
function Point2D:GetX() end

-- Point2D - method
function Point2D:GetY() end

-- Point2D - method
function Point2D:SetX(x) end

-- Point2D - method
function Point2D:SetY(y) end

-- Point2D - method
function Point2D:Offset(dx, dy) end

-- Point2D - method
function Point2D:DistanceTo(otherPoint) end

Rect2D = {}

-- Rect2D - method
function Rect2D:GetWidth() end

-- Rect2D - method
function Rect2D:GetHeight() end

-- Rect2D - method
function Rect2D:GetMinX() end

-- Rect2D - method
function Rect2D:GetMinY() end

-- Rect2D - method
function Rect2D:GetMaxX() end

-- Rect2D - method
function Rect2D:GetMaxY() end

-- Rect2D - method
function Rect2D:Center() end

-- Rect2D - method
function Rect2D:Expand(amount) end

-- Rect2D - method
function Rect2D:ContainsPoint(point) end

DrawingTool = {}

-- DrawingTool - method
function DrawingTool:DrawLine(x1, y1, x2, y2) end

-- DrawingTool - method
function DrawingTool:DrawArc(x1, y1, x2, y2, bulge) end

-- DrawingTool - method
function DrawingTool:DrawCircle(x, y, radius) end

-- DrawingTool - method
function DrawingTool:DrawRectangle(x1, y1, x2, y2) end

-- DrawingTool - method
function DrawingTool:DrawPolyline(points) end

-- DrawingTool - method
function DrawingTool:DrawBezier(x1, y1, c1x, c1y, c2x, c2y, x2, y2) end

ScriptInterface = {}

-- ScriptInterface - method
function ScriptInterface:GetJob() end

-- ScriptInterface - method
function ScriptInterface:GetAppVersion() end

-- ScriptInterface - method
function ScriptInterface:ShowMessageBox(text) end

-- ScriptInterface - method
function ScriptInterface:CreateDialog() end

-- ScriptInterface - method
function ScriptInterface:RefreshDisplay() end

-- ScriptInterface - method
function ScriptInterface:LogMessage(message) end

-- ScriptInterface - method
function ScriptInterface:GetCurrentLayerName() end

DocumentVariableManager = {}

-- DocumentVariableManager - method
function DocumentVariableManager:GetVariable(name) end

-- DocumentVariableManager - method
function DocumentVariableManager:SetVariable(name, value) end

-- DocumentVariableManager - method
function DocumentVariableManager:DeleteVariable(name) end

-- DocumentVariableManager - method
function DocumentVariableManager:ListVariables() end

PostProcessor = {}

-- PostProcessor - method
function PostProcessor:GetName() end

-- PostProcessor - method
function PostProcessor:GetDescription() end

-- PostProcessor - method
function PostProcessor:SetProperty(name, value) end

-- PostProcessor - method
function PostProcessor:GetProperty(name) end

MeasurementTool = {}

-- MeasurementTool - method
function MeasurementTool:MeasureDistance(x1, y1, x2, y2) end

-- MeasurementTool - method
function MeasurementTool:MeasureAngle(x1, y1, x2, y2, x3, y3) end

-- MeasurementTool - method
function MeasurementTool:MeasureArcLength(center_x, center_y, radius, angle_deg) end

FileDialogs = {}

-- FileDialogs - method
function FileDialogs:ShowOpenDialog(title, filter, default_path) end

-- FileDialogs - method
function FileDialogs:ShowSaveDialog(title, filter, default_path) end

-- FileDialogs - method
function FileDialogs:ShowFolderDialog(title, default_path) end

