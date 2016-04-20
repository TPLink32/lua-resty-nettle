local require = require
local yarrow = require "resty.nettle.yarrow".new(require "resty.nettle.knuth-lfib".new():random(32))
local assert = assert
local string = string
local type = type
local char = string.char
local byte = string.byte
local sub = string.sub
local padding = {}
function padding.pad(data, blocksize)
    blocksize = blocksize or 16
    assert(type(blocksize) == "number" and blocksize > 0 and blocksize < 257, "Invalid block size")
    local ps = blocksize - #data % blocksize
    if ps == 0 then
        ps = blocksize
    end
    return data .. yarrow:random(ps - 1) .. char(ps)
end
function padding.unpad(data, blocksize)
    blocksize = blocksize or 16
    assert(type(blocksize) == "number" and blocksize > 0 and blocksize < 257, "Invalid block size")
    local len = #data
    assert(len % blocksize == 0, "Data's length is not a multiple of the block size")
    local chr = sub(data, -1)
    local rem = byte(chr)
    assert(rem > 0 and rem <= blocksize, "Invalid padding found")
    return sub(data, 1, len - rem)
end
return padding