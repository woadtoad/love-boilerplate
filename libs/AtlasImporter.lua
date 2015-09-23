function loadAtlas(lua,png)
    local TextureAtlas = {}
    --atlas file is exported from texture packer
    local atlas = require (lua)
    local data = atlas.getSpriteSheetData()

    --frames holds the data that we need to interpret
    local frames = data.frames
    local tex = love.graphics.newImage( png )

    local Quads = {}
    --extra holds the offset data
    local Extra = {}
    local Size = {}

    --make sure offsets and quads are all right
    for i=1,#frames do
        local rect = frames[i].textureRect
        local offset = frames[i].spriteColorRect


        local x = rect.x
        local y = rect.y
        local height = rect.height
        local width = rect.width
        local th = tex:getHeight ()
        local tw = tex:getWidth ()

        Quads[frames[i].name] = love.graphics.newQuad(x, y, width, height, tw,th )

        Extra[frames[i].name] = {offset.x,offset.y}


        Size[frames[i].name] = frames[i].spriteSourceSize

    end

    TextureAtlas.quads = Quads
    TextureAtlas.texture = tex
    TextureAtlas.extra = Extra
    TextureAtlas.size = Size

    return TextureAtlas
end