# -*- coding: mbcs -*-
#
# Abaqus/Viewer Release 6.12-2 replay file
# Internal Version: 2012_06_28-23.52.08 119883
# Run by labergere on Wed Feb 03 09:17:15 2016
#

# from driverUtils import executeOnCaeGraphicsStartup
# executeOnCaeGraphicsStartup()
#: Executing "onCaeGraphicsStartup()" in the site directory ...
from abaqus import *
from abaqusConstants import *
session.Viewport(name='Viewport: 1', origin=(0.0, 0.0), width=300., 
    height=100.)
session.viewports['Viewport: 1'].makeCurrent()
session.viewports['Viewport: 1'].maximize()
from viewerModules import *
from driverUtils import executeOnCaeStartup
executeOnCaeStartup()
o2 = session.openOdb(name='auto_inp.odb')
#: Model: D:/OPTIMISATION/plaquePercee/Plaque.odb
#: Number of Assemblies:         1
#: Number of Assembly instances: 0
#: Number of Part instances:     1
#: Number of Meshes:             1
#: Number of Element Sets:       5
#: Number of Node Sets:          5
#: Number of Steps:              1
session.viewports['Viewport: 1'].setValues(displayedObject=o2)
odb = session.odbs['auto_inp.odb']
session.writeFieldReport(
    fileName='./STRESS+MISES.rpt', append=ON, 
    sortItem='Element Label', odb=odb, step=0, frame=1, 
    outputPosition=INTEGRATION_POINT, variable=(('S', INTEGRATION_POINT, ((
    INVARIANT, 'Mises'), (COMPONENT, 'S11'),(COMPONENT, 'S12'), (COMPONENT, 'S22') )), ))
odb = session.odbs['auto_inp.odb']
session.writeFieldReport(
    fileName='./DEPLACEMENT.rpt', append=ON, 
    sortItem='Node Label', odb=odb, step=0, frame=1, outputPosition=NODAL, 
    variable=(('U', NODAL, ((COMPONENT, 'U1'), (COMPONENT, 'U2'), )), ))
