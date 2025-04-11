return {
  -- Vectric gadget libray
  -- Global Methods
  DisplayMessageBox = {  -- Name of function
	type = 'function', -- do not change
	args = '(string message)',
	returns = '(Returns: none)',
	description = "Displays MessageBox to user",
  },
  IsAspire = {  -- Name of function
	type = 'function', -- do not change
	args = '(none)',
	returns = '(Returns: boolean)',
	description = "Returns true if the script is running inside Aspire",
  },
  IsBetaBuild = {  -- Name of function
	type = 'function', -- do not change
	args = '(none)',
	returns = '(Returns: boolean)',
	description = "returns true if this is a Beta build rather than a release build",
  },
  GetAppVersion = {  -- Name of function
	type = 'function', -- do not change
	args = '(none)',
	returns = '(Returns: double)',
	description = "Returns application version number as a double e.g 4.004 for Aspire V4.0",
  },
  GetBuildVersion = {  -- Name of function
	type = 'function', -- do not change
	args = '(none)',
	returns = '(Returns: double)',
	description = "Returns application internal build verion",
  },
  MessageBox = {  -- Name of function
	type = 'function', -- do not change
	args = '(string)',
	returns = '(Returns: none)',
	description = "Displays a message box with passed text to user",
  },
  -- Job related global methods
  CloseCurrentJob = {  -- Name of function
	type = 'function', -- do not change
	args = '(none)',
	returns = '(Returns: boolean)',
	description = "Close the current job with same as File, will be promp to save if needed",
  },
  CreateNewJob = {  -- Name of function
	type = 'function', -- do not change
	args = '(string name, Box2D bounds, double thickness, bool in_mm, bool origin_on_surface)',
	returns = '(Returns: boolean)',
	description = "Creates a new job. Returns true if job created OK else false.",
  },
  CreateNew2SidedJob = {  -- Name of function
	type = 'function', -- do not change
	args = '(string name, Box2D bounds, double thickness, bool in_mm, bool origin_on_surface, SideFlipDirection flip_direction)',
	returns = '(Returns: boolean)',
	description = "Creates a new two sided job. Return true if the job was created, otherwise, false",
  },
  CreateNewRotaryJob = {  -- Name of function
	type = 'function', -- do not change
	args = '(string name, double length, double diameter, MaterialBlock.XYOrigin xy_origin, bool in_mm, bool origin_on_surface, bool wrapped_along_x_axis)',
	returns = '(Returns: boolean)',
	description = "Creates a new rotary job using the given parameters. Return true if the job was created, otherwise, false",
  },
  OpenExistingJob = {  -- Name of function
	type = 'function', -- do not change
	args = '(string pathname)',
	returns = '(Returns: boolean)',
	description = "Opens an existing CRV or CRV3D file. Returns true if file opened OK, else false",
  },
  SaveCurrentJob = {  -- Name of function
	type = 'function', -- do not change
	args = '(none)',
	returns = '(Returns: boolean)',
	description = "Save the current job, if no path has been set for the job this method will display the File Save As dialog",
  },
  -- Vector object related global methods
  CastCadObjectToCadBitmap = {  -- Name of function
	type = 'function', -- do not change
	args = '(CadObject object)',
	returns = '(Returns: CadBitmap)',
	description = "Casts passed CadObject to a CadBitmap - returns a CadBitmap object to work with",
  },
  CastCadObjectToCadContour = {  -- Name of function
	type = 'function', -- do not change
	args = '(CadObject object)',
	returns = '(Returns: CadContour object)',
	description = "Casts passed CadObject to a CadContour - returns a CadContour object to work with",
  },
  CastCadObjectToCadObjectGroup = {  -- Name of function
	type = 'function', -- do not change
	args = '(CadObject object)',
	returns = '(Returns: CadObjectGroup object)',
	description = "Casts passed CadObject to a CadObjectGroup - returns a CadObjectGroup object to work with",
  },
  CastCadObjectToCadPolyline = {  -- Name of function
	type = 'function', -- do not change
	args = '(CadObject object)',
	returns = '(Returns: CadPolyline object)',
	description = "Casts passed CadObject to a CadPolyline - returns a CadPolyline object to work with",
  },
  CastCadObjectToCadToolpathPreview = {  -- Name of function
	type = 'function', -- do not change
	args = '(CadObject object)',
	returns = '(Returns: CadToolpathPreview object)',
	description = "Casts passed CadObject to a CadToolpathPreview - returns a CadToolpathPreview object to work with",
  },
  CastCadObjectToTxtBlock = {  -- Name of function
	type = 'function', -- do not change
	args = '(CadObject object)',
	returns = '(Returns: TxtBlock object)',
	description = "Casts passed CadObject to a TxtBlock - returns a TxtBlock object",
  },

  CreateCircle = {  -- Name of function
	type = 'function', -- do not change
	args = '(double x, double y, double radius, double tolerance, double z_value)',
	returns = '(Returns: none)',
	description = "Create a Contour object for a circle consisting of 4 arcs",
  },
  CreateCopyOfSelectedContours = {  -- Name of function
	type = 'function', -- do not change
	args = '(boolean smash_beziers, boolean smash_arcs, double smash_tol)',
	returns = '(Returns: none)',
	description = "Create a ContourGroup containing a copy of the currently selected contours in the job",
  },
  -- Component Related Global Methods – Aspire only
  IsTransparent = {  -- Name of function
	type = 'function', -- do not change
	args = '(float value)',
	returns = '(Returns: boolean)',
	description = "Aspire only - Returns true if the specified value is considered transparent",
  },
  GetTransparentHeight = {  -- Name of function
	type = 'function', -- do not change
	args = '(none)',
	returns = '(Returns: float)',
	description = "Aspire only - Returns as a float the heights in reliefs considered transparent. This is the value used internally to represent a ‘transparent’ point",
  },
  CastComponentToComponentGroup = {  -- Name of function
	type = 'function', -- do not change
	args = '(Component component)',
	returns = '(Returns: ComponentGroup object)',
	description = "Aspire only - Casts passed Component to a ComponentGroup - returns a ComponentGroup object to work with",
  },
  -- DocumentVariable Related Global Methods
  IsInvalidDocumentVariableName = {  -- Name of function
	type = 'function', -- do not change
	args = '(string name)',
	returns = '(Returns: boolean)',
	description = "Returns true if the passed name is invalid for a DocumentVariable",
  },
  -- Data file locations related global methods
  GetDataLocation = {  -- Name of function
	type = 'function', -- do not change
	args = '(none)',
	returns = '(Returns: string)',
	description = "Returns the location path for the application",
  },
  GetPostProcessorLocation = {  -- Name of function
	type = 'function', -- do not change
	args = '(none)',
	returns = '(Returns: string)',
	description = "Returns the PostP location path for the program",
  },
  GetToolDatabaseLocation = {  -- Name of function
	type = 'function', -- do not change
	args = '(none)',
	returns = '(Returns: string)',
	description = "Returns the Tool Database location path for the program",
  },
  GetGadgetsLocation = {  -- Name of function
	type = 'function', -- do not change
	args = '(none)',
	returns = '(Returns: string)',
	description = "Returns the Gadgets location path for the program",
  },
  GetToolpathDefaultsLocation = {  -- Name of function
	type = 'function', -- do not change
	args = '(none)',
	returns = '(Returns: string)',
	description = "Returns the ToolpathDefaults path for the program",
  },
  GetBitmapTexturesLocation = {  -- Name of function
	type = 'function', -- do not change
	args = '(none)',
	returns = '(Returns: string)',
	description = "Returns the BitmapTextures location path for the program which stores the bitmaps used for displaying different material types",
  },
  GetVectorTexturesLocation = {  -- Name of function
	type = 'function', -- do not change
	args = '(none)',
	returns = '(Returns: string)',
	description = "Returns VectorTextures location path for the program",
  },
  CreateCadContour = {  -- Name of function
	type = 'function', -- do not change
	args = '(Contour ctr)',
	returns = '(Returns: object)',
	description = "Returns a CadContour which owns the passed Contour object",
  },
  CreateCadGroup = {  -- Name of function
	type = 'function', -- do not change
	args = '(Contour ctr))',
	returns = '(Returns: group)',
	description = "Returns a CadContourGroup which owns the passed ContourGroup object",
  },
  GetDefaultContourTolerance = {  -- Name of function
	type = 'function', -- do not change
	args = '(none)',
	returns = '(Returns: double)',
	description = "Returns a value which is the default value for contour tolerances used within the program",
  },
  -- MaterialBlock
  MaterialBlock = {  -- Name of function
	type = 'function', -- do not change
	args = '(none)',
	returns = '(Returns: string)',
	description = "Constructs new single material block",
  },
  CalcAbsoluteZ = {  -- Name of function
	type = 'function', -- do not change
	args = '(double z_value)',
	returns = '(Returns: double)',
	description = "Returns an ‘absolute’ z value from a z value relative to the surface of the block",
  },
  -- CadMarker
  CadMarker = {  -- Name of function
	type = 'function', -- do not change
	args = '(string text, Point2D pt, integer pixel_size)',
	returns = '(none)',
	description = "A CadMarker at passed position",
  },
  -- CadObjectList
  CadObjectList = {  -- Name of function
	type = 'function', -- do not change
	args = '(boolean owns_objects)',
	returns = '(CadObjectList)',
	description = "Creates a new CadObjectList",
  },
  Contour = {  -- Name of function
	type = 'function', -- do not change
	args = '(0.0)',
	returns = '(none)',
	description = "Constructor - Starts new vector object",
  },
  ContourGroup = {  -- Name of function
	type = 'function', -- do not change
	args = '(boolean owns_objects)',
	returns = '(none)',
	description = "Create a new empty ContourGroup object",
  },
  ContourGroup = {  -- Name of function
	type = 'function', -- do not change
	args = '(boolean owns_objects)',
	returns = '(none)',
	description = "Create a new empty ContourGroup object",
  },
  ContourCarriage = {  -- Name of function
	type = 'function', -- do not change
	args = '((Contour ctr, Point2D pt)/(Integer span_index, double parameter))',
	returns = '(none)',
	description = "Creates a ‘carriage’ for the passed contour and positions it at the nearest point on the contour to the passed point / Creates a ‘carriage’ for a contour and set its positions for the span with the passed index at the passed parameter position (in range 0-1.0) on the span",
  },

  Span = {  -- Name of function
	type = 'function', -- do not change
	args = '(Point3D pt3d)',
	returns = '(none)',
	description = "A new span representing a single point is created within a Lua script using this contructor method",
  },

  LineSpan = {  -- Name of function
	type = 'function', -- do not change
	args = '(start_point, end_point)',
	returns = '(none)',
	description = "A new 2D or 3D span representing a line",
  },

  ArcSpan = {  -- Name of function
	type = 'function', -- do not change
	args = '(start_point, end_point, (arc_point or bulge))',
	returns = '(none)',
	description = "A new span representing an arc is created",
  },

  BezierSpan = {  -- Name of function
	type = 'function', -- do not change
	args = '(Point2D start_pt, Point2D end_pt, Point2D ctrl_pt_1, Point2D ctrl_pt_1))',
	returns = '(none)',
	description = "A new span representing a bezier is created",
  },
  Point2D = {  -- Name of function
	type = 'function', -- do not change
	args = '(double x, double y)',
	returns = '(none)',
	description = "A new 2D point with the specified X and Y values",
  },
  Point3D = {  -- Name of function
	type = 'function', -- do not change
	args = '(double x, double y, double z)',
	returns = '(none)',
	description = "A new 3D point with the specified X, Y and Z values",
  },
  Vector2D = {  -- Name of function
	type = 'function', -- do not change
	args = '(double x, double y)',
	returns = '(none)',
	description = "A 2D vector point with the specified X and Y values",
  },
  Vector3D = {  -- Name of function
	type = 'function', -- do not change
	args = '(double x, double y)',
	returns = '(none)',
	description = "A 3D vector point with the specified X, Y and Z values",
  },
  Box2D = {  -- Name of function
	type = 'function', -- do not change
	args = '(double x, double y / Box2D box)',
	returns = '(none)',
	description = "Create a box which bounds the 2 passed in points / A new Box2D with the same values as the passed box",
  },

  IdentityMatrix2D = {  -- Name of function
	type = 'function', -- do not change
	args = '(none)',
	returns = 'Matrix2D',
	description = "Returns a Matrix2D which is an identity matrix",
  },
  ReflectionMatrix2D = {  -- Name of function
	type = 'function', -- do not change
	args = '(Point2D p1, Point2D p2)',
	returns = 'Matrix2D',
	description = "Create a box which bounds the 2 passed in points / A new Box2D with the same values as the passed box",
  },
  RotationMatrix2D = {  -- Name of function
	type = 'function', -- do not change
	args = '(Point2D rotation_pt, double angle)',
	returns = 'Matrix2D',
	description = "Returns a Matrix2D which is performs the rotation about the specified point by the specified amount",
  },
  ScalingMatrix2D = {  -- Name of function
	type = 'function', -- do not change
	args = '(Vector2D scale_vec)',
	returns = 'Matrix2D',
	description = "Returns a Matrix2D which performs the scaling around the origin (0,0) by the specified amount",
  },
  TranslationMatrix2D = {  -- Name of function
	type = 'function', -- do not change
	args = '(Point2D rotation_pt, double angle)',
	returns = 'Matrix2D',
	description = "Returns a Matrix2D which is performs the translation specified by the vector",
  },
  -- Tool Path
  ToolpathManager = {  -- Name of function
	type = 'function', -- do not change
	args = '(none)',
	returns = '(object)',
	description = "Returns a new object which refers to the single toolpath manager within the program",
  },
  CreatePocketingToolpath = {  -- Name of function
	type = 'function', -- do not change
	args = '(String name, Tool tool, Tool area_clear_tool, PocketParameterData pocket_data, ToolpathPosData pos_data, GeometrySelector geometry_selector, bool create_2d_preview, bool interactive)',
	returns = '(UUID)',
	description = "Creates a pocketing toolpath for the currently selected vectors",
  },
  CreateDrillingToolpath = {  -- Name of function
	type = 'function', -- do not change
	args = '(String name, Tool tool, DrillParameterData drilling_data, ToolpathPosData pos_data, GeometrySelector geometry_selector, bool create_2d_preview, bool interactive)',
	returns = '(UUID)',
	description = "Creates a drilling toolpath for the currently selected vectors",
  },
  CreateVCarvingToolpath = {  -- Name of function
	type = 'function', -- do not change
	args = '(String name,Tool tool,Tool area_clear_tool, VCarveParameterData vcarve_data, PocketParameterData pocket_data, ToolpathPosData pos_data, GeometrySelector geometry_selector, bool create_2d_preview, bool interactive)',
	returns = '(UUID)',
	description = "Creates a vcarving toolpath for the currently selected vectors",
  },
  CreatePrismCarvingToolpath = {  -- Name of function
	type = 'function', -- do not change
	args = '(String name, Tool tool, PrismCarveParameterData prism_data, ToolpathPosData pos_data, GeometrySelector geometry_selector, bool create_2d_preview, bool interactive)',
	returns = '(UUID)',
	description = "Returns a new object which refers to the single toolpath manager within the program",
  },
  CreateFlutingToolpath = {  -- Name of function
	type = 'function', -- do not change
	args = '(String name, Tool tool, FlutingParameterDatafluting_data, ToolpathPosData pos_data, GeometrySelector geometry_selector, bool create_2d_preview, bool interactive)',
	returns = '(UUID)',
	description = "Creates a fluting toolpath for the currently selected vectors",
  },
  CreateRoughingToolpath = {  -- Name of function
	type = 'function', -- do not change
	args = '(String name, Tool tool, RoughingParameterData roughing_ data, ToolpathPosData pos_data, GeometrySelector geometry_selector, bool interactive)',
	returns = '(UUID)',
	description = "Creates a roughing toolpath",
  },
  CreateFinishingToolpath = {  -- Name of function
	type = 'function', -- do not change
	args = '(String name, Tool tool, PocketParameterData pocket_data, ToolpathPosData pos_data, GeometrySelector geometry_selector, bool create_2d_preview, bool interactive)',
	returns = '(UUID)',
	description = "Creates a finishing toolpath for the currently selected vectors",
  },
  CreateFinishingToolpath = {  -- Name of function
	type = 'function', -- do not change
	args = '(String name, Tool tool, PocketParameterData pocket_data, ToolpathPosData pos_data, GeometrySelector geometry_selector, bool create_2d_preview, bool interactive)',
	returns = '(UUID)',
	description = "Creates a finishing toolpath for the currently selected vectors",
  },
  -- Tool Database
  ToolDatabase = {  -- Name of function
	type = 'function', -- do not change
	args = '(none)',
	returns = '(object)',
	description = "Returns a new object which gives access to the single Tool database for the program",
  },
  Tool = {  -- Name of function
	type = 'function', -- do not change
	args = '(string name, ToolType tool_type)',
	returns = '(object)',
	description = "Create a new tool",
  },
  ToolpathPosData = {  -- Name of function
	type = 'function', -- do not change
	args = '(none)',
	returns = '(object)',
	description = "Creates a new ToolpathPosData object with default values",
  },
  GeometrySelector = {  -- Name of function
	type = 'function', -- do not change
	args = '(none)',
	returns = '(object)',
	description = "Creates a new GeomterySelector object with default values",
  },
  ProfileParameterData = {  -- Name of function
	type = 'function', -- do not change
	args = '(none)',
	returns = '(object)',
	description = "Create a new object ready to have its parameters set",
  },
  RampingData = {  -- Name of function
	type = 'function', -- do not change
	args = '(none)',
	returns = '(object)',
	description = "Create a new object ready to have its parameters set",
  },
  LeadInData = {  -- Name of function
	type = 'function', -- do not change
	args = '(none)',
	returns = '(object)',
	description = "Create a new object ready to have its parameters set",
  },
  ProfileParameterData = {  -- Name of function
	type = 'function', -- do not change
	args = '(none)',
	returns = '(object)',
	description = "Create a new object ready to have its parameters set",
  },
  DrillParameterData = {  -- Name of function
	type = 'function', -- do not change
	args = '(none)',
	returns = '(object)',
	description = "Create a new object ready to have its parameters set",
  },
  VCarveParameterData = {  -- Name of function
	type = 'function', -- do not change
	args = '(none)',
	returns = '(object)',
	description = "Create a new object ready to have its parameters set",
  },
  FlutingParameterData = {  -- Name of function
	type = 'function', -- do not change
	args = '(none)',
	returns = '(object)',
	description = "Create a new object ready to have its parameters set",
  },
  PrismCarveParameterData = {  -- Name of function
	type = 'function', -- do not change
	args = '(none)',
	returns = '(object)',
	description = "Create a new object ready to have its parameters set",
  },
  RoughingParameterData = {  -- Name of function
	type = 'function', -- do not change
	args = '(none)',
	returns = '(object)',
	description = "Aspire Only - Create a new object ready to have its parameters set",
  },
  FininshingParameterData = {  -- Name of function
	type = 'function', -- do not change
	args = '(none)',
	returns = '(object)',
	description = "Aspire Only - Create a new object ready to have its parameters set",
  },
  ExternalToolpath = {  -- Name of function
	type = 'function', -- do not change
	args = '(string name, Tool tool, ToolpathPosData pos_data, ExternalToolpathOptions options, ContourGroup contours)',
	returns = '(object)',
	description = "Create a new toolpath object",
  },
  ExternalToolpathOptions = {  -- Name of function
	type = 'function', -- do not change
	args = '(none)',
	returns = '(object)',
	description = "Create a new object ready to have its parameters set",
  },
  ToolpathSaver = {  -- Name of function
	type = 'function', -- do not change
	args = '(none)',
	returns = '(object)',
	description = "Create a new object which can be used to save toolpaths",
  },
  -- User Interface
  HTML_Dialog = {  -- Name of function
	type = 'function', -- do not change
	args = '(bool local_html, string html, integer width, integer height, string dialog_name)',
	returns = '(object)',
	description = "Create a new dialog object",
  },
  FileDialog = {  -- Name of function
	type = 'function', -- do not change
	args = '(none)',
	returns = '(object)',
	description = "Create a new object used for displaying a File Open / Save dialog",
  },
  DirectoryReader = {  -- Name of function
	type = 'function', -- do not change
	args = '(none)',
	returns = '(object)',
	description = "Create a new object used for building lists of files",
  },
  ProgressBar = {  -- Name of function
	type = 'function', -- do not change
	args = '(string text, ProgressBarMode progress_bar_mode)',
	returns = '(object)',
	description = "Creates a new progress bar and displays it in the host program",
  },
  -- Registry
  Registry = {  -- Name of function
	type = 'function', -- do not change
	args = '(string section_name)',
	returns = '(object)',
	description = "Create a new object used for reading and writing values",
  },
  -- Easy libray
  Polar2D = {  -- Name of function
	type = 'function', -- do not change
	args = '(point: 2Dpoint, ang: double, dist: double)',
	returns = '(Returns: 2Dpoint)',
	description = "calculates 2Dpoint from a point based on angle and distance",
  },
}
