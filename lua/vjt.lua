--[===[
Jump between class and test
--]===]
local do_test = false


local api = vim.api

local function find_test(f)
    local f = f:gsub("^src/main", "src/test"):gsub("%.java$", "Test.java")
    if f == nil then 
        return nil, "Test Class not found."
    else 
        io.close()
        return f 
    end
    return f
end

local function find_class(f)
    local f = f:gsub("^src/test", "src/main"):gsub("Test%.java", ".java")
    -- check if file exists
    local cf = io.open(f, "rb")
    if f == nil then 
        return nil, "Class not found."
    else 
        io.close()
        return f 
    end
end

local function vjt()
    local buf = vim.fn.bufname()
    local bufname = vim.fn.fnamemodify(buf, ':p')

    local f, err
    if bufname:match("^src/main") then
        f, err = find_test(bufname)
    else
        f, err = find_class(bufname)
    end
    if (f) then
        api.nvim_command('edit '..f)
    else
        print(err)
    end
end


-- tests
if do_test then
    assert( "src/test/java/com/truc/app/op/ClassTest.java" == find_test("src/main/java/com/truc/app/op/Class.java") )
    assert( "src/main/java/com/truc/app/op/Class.java" == find_class("src/test/java/com/truc/app/op/ClassTest.java"))
end

return {
    vjt = vjt
}
