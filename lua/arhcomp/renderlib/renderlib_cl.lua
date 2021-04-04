-- See renderlib.lua top comment

local SurfTempToSTIndex = {}
local STIndexToSurfTemp = {}

function ArhComp.RenderLib.ImplCl_RegisterSurfaceTemplate(templateName, template)
    SurfTempToSTIndex[template] = templateName
    SurfTempToSTIndex[templateName] = template
end

local AllocatedSurfaces = {}


local function AllocateSurfaceImpl(index, templateName, size)
    local template = STIndexToSurfTemp[templateName]
    local opaque = templateName.Opaque

    local rtName = "arhcomp_rt_" .. templateName .. "_inst_" .. tostring(index)

    local rt = GetRenderTargetEx(rtName,
        size.X, size.Y, RT_SIZE_NO_CHANGE, MATERIAL_RT_DEPTH_NONE, 
        bit.bor(TEXTUREFLAGS_ANISOTROPIC, Either(opaque, 0, TEXTUREFLAGS_EIGHTBITALPHA), TEXTUREFLAGS_RENDERTARGET),
        0, Either(opaque, IMAGE_FORMAT_RGB888, IMAGE_FORMAT_RGBA8888)) -- rtFlags, imageFormat

    local shader            = template.Shader
    local matTableFactory   = template.MaterialTableFactory

    local mat = CreateMaterial(rtName, shader, matTableFactory(rtName))

    return mat
end

local function AllocateSurface(templateName, size)
    local put_to = AllocatedSurfaces[templateName] or {}
    local index = #put_to + 1

    local material = AllocateSurfaceImpl(index, templateName, size)

    local surf = { Material = material, Used = false }

    put_to[index] = surf

    AllocatedSurfaces[templateName] = put_to

    return surf
end

local function GetOrAllocateSurface(templateName, size)
    local surfacesOfTemplate = AllocatedSurfaces[templateName]

    for i, surf in ipairs(surfacesOfTemplate or {}) do
        if not surf.Used then
            return surf
        end
    end

    return AllocateSurface(templateName, size)
end

hook.Add("PostDrawOpaqueRenderables", "ArhComp_PostDrawOpaqueRenderables", function(is_depth, is_skybox)
    if is_depth or is_skybox then return end

    
end)