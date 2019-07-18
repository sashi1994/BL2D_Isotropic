from driverConstants import *
from driverStandard import StandardAnalysis
import driverUtils, sys
options = {
    'SIMExt':'.sim',
    'ams':OFF,
    'analysisType':STANDARD,
    'applicationName':'analysis',
    'aqua':OFF,
    'ask_delete':OFF,
    'beamSectGen':OFF,
    'biorid':OFF,
    'cavityTypes':[],
    'cavparallel':OFF,
    'complexFrequency':OFF,
    'contact':OFF,
    'cosimulation':OFF,
    'coupledProcedure':OFF,
    'cse':OFF,
    'cyclicSymmetryModel':OFF,
    'directCyclic':OFF,
    'direct_solver':DMP,
    'dsa':OFF,
    'dynamic':OFF,
    'filPrt':[],
    'fils':[],
    'finitesliding':OFF,
    'foundation':ON,
    'geostatic':OFF,
    'geotech':OFF,
    'heatTransfer':OFF,
    'importer':OFF,
    'importerParts':OFF,
    'includes':[],
    'initialConditionsFile':OFF,
    'input':'auto_inp',
    'inputFormat':INP,
    'interactive':None,
    'job':'auto_inp',
    'keyword_licenses':[],
    'lanczos':OFF,
    'libs':[],
    'magnetostatic':OFF,
    'massDiffusion':OFF,
    'modifiedTet':OFF,
    'moldflowFiles':[],
    'moldflowMaterial':OFF,
    'mp_mode':THREADS,
    'mp_mode_requested':MPI,
    'multiphysics':OFF,
    'noDmpDirect':[],
    'noMultiHost':[],
    'noMultiHostElemLoop':[],
    'no_domain_check':1,
    'outputKeywords':ON,
    'parameterized':OFF,
    'partsAndAssemblies':ON,
    'parval':OFF,
    'postOutput':OFF,
    'preDecomposition':ON,
    'restart':OFF,
    'restartEndStep':OFF,
    'restartIncrement':0,
    'restartStep':0,
    'restartWrite':OFF,
    'rezone':OFF,
    'runCalculator':OFF,
    'soils':OFF,
    'soliter':OFF,
    'solverTypes':['DIRECT'],
    'standard_parallel':ALL,
    'staticNonlinear':OFF,
    'steadyStateTransport':OFF,
    'step':ON,
    'subGen':OFF,
    'subGenLibs':[],
    'subGenTypes':[],
    'submodel':OFF,
    'substrLibDefs':OFF,
    'substructure':OFF,
    'symmetricModelGeneration':OFF,
    'thermal':OFF,
    'tmpdir':'C:\\Users\\maduguls\\AppData\\Local\\Temp',
    'tracer':OFF,
    'visco':OFF,
}
analysis = StandardAnalysis(options)
status = analysis.run()
sys.exit(status)
