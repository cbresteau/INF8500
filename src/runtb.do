if [file exists work] {
  vdel -lib ./work -all
}

echo "###"
echo "### Creating library and compiling design ..."
echo "###"

# Création de la librairie de travail
vlib work

# Compilation du module test (DUT)
vlog Sharp_LR35902_alu.v

# Compilation du banc de test
# La commande -mfcu indique au compilateur de traiter tout les fichier dans une même unité de compilation.
vlog -sv -mfcu aluTOP.sv TestBenchDefs.sv Interface_to_alu.sv Driver.sv TestProgram.sv TestBenchTOP.sv Receiver.sv  Generator.sv

# Afficher les vue de debuggage
quietly view *

# Lancement du simulateur et du banc de test
# La commande -t ns spécifie la résolution temporel en nanoseconde au simulateur
vsim -t ns work.TestBenchTOP

# Affichage et configuration de la fenêtre de visualisation des traces
add wave -r *

# Execution du banc de test pour 14 cycle d'horloge (14 * 200ns)
run 2800ns

#coverage report -detail -cvg -file rapport.txt
