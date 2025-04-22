#!/bin/bash

# Define base directory
PROJECT_DIR="$HOME/BESS_Project_Simulations"

# Create directories
mkdir -p "$PROJECT_DIR/Output_Plots"
mkdir -p "$PROJECT_DIR/Final_Report"

# Create empty Simulink model placeholders
touch "$PROJECT_DIR/Internal_Fault.slx"
touch "$PROJECT_DIR/Grid_Sag_VF_Control.slx"
touch "$PROJECT_DIR/SOC_Rebalance.slx"
touch "$PROJECT_DIR/DWT_Fault_Detection.slx"

# Create placeholder image files
touch "$PROJECT_DIR/Output_Plots/current_spike.png"
touch "$PROJECT_DIR/Output_Plots/SOC_comparison.png"
touch "$PROJECT_DIR/Output_Plots/VF_response.png"

# Create report docx placeholder
touch "$PROJECT_DIR/Final_Report/All_Figures_Annotated.docx"

# Output status
echo "✅ BESS Simulation Project Structure created at:"
echo "$PROJECT_DIR"
tree "$PROJECT_DIR"
