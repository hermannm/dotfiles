if [ $(gsettings get org.gnome.desktop.interface text-scaling-factor) = "1.0" ]; then
    gsettings set org.gnome.desktop.interface text-scaling-factor 1.15
else
    gsettings reset org.gnome.desktop.interface text-scaling-factor
fi
