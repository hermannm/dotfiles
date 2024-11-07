# How to make into .app to launch at startup: https://stackoverflow.com/a/6445525
#
# First 2 entries:
# - Switch Right Command (0x7000000e7) and Right Option (0x7000000e6)
#
# Last 2 entries:
# - Switch Left Shift (0x7000000e1) and Caps Lock (0x700000039)
hidutil property --set '{
  "UserKeyMapping": [
    {
      "HIDKeyboardModifierMappingSrc":0x7000000e7,
      "HIDKeyboardModifierMappingDst":0x7000000e6
    },
    {
      "HIDKeyboardModifierMappingSrc":0x7000000e6,
      "HIDKeyboardModifierMappingDst":0x7000000e7
    },
    {
      "HIDKeyboardModifierMappingSrc":0x7000000e1,
      "HIDKeyboardModifierMappingDst":0x700000039
    },
    {
      "HIDKeyboardModifierMappingSrc":0x700000039,
      "HIDKeyboardModifierMappingDst":0x7000000e1
    }
  ]
}'
