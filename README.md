# TernaryAndOxidePlottingSoftware

This series of matlab scripts reads in geochemical data from an excel spreadsheet and plots in (1) oxide-oxide space (2) ternary space. The code is adaptable to your needs.  For example, control the appearance of data (color, linewidth, etc...) using the "Legend" worksheet in the excel spreadsheet. 

To use: run "RUN_plotMASTER" which generates a variety of figures.  Within each MATLAB Section (Steps 1-4), customize to your specific needs by rerunning the section using the "Run Section" command. 

    Step 1: 1x2 oxide-oxide plot
  
    Step 2: 4 6x2 oxide-oxide plots
  
    Step 3: Ternary figures
  
    Step 4: Trace Element Spider Diagrams (will greatly improve)

To save figures (Step 5): 

    use savefigs('text2append','NameOfNewOrExistingFolder2Save')
