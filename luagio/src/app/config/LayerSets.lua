local layerSets = {}

layerSets[cc.viewTypes.PANEL]     = {zorder=1,cls="PanelLayer",}
layerSets[cc.viewTypes.INFO]      = {zorder=1,cls="InfoLayer",}
layerSets[cc.viewTypes.DIALOG]    = {zorder=2,cls="DialogLayer",}
layerSets[cc.viewTypes.LOADING]   = {zorder=3,}
layerSets[cc.viewTypes.GUIDE]     = {zorder=4,}
layerSets[cc.viewTypes.TIP]       = {zorder=5,}

return layerSets