local CCSPanel = class("CCSPanel")

function CCSPanel:create(path)
   return cc.CSLoader:createNode(cc.cfm.getCSBFile(path))
end

return CCSPanel