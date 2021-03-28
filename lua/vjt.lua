--[===[
Jump between class and test
--]===]
local do_test = false


local api = vim.api

local function is_file_exists(f)
    local cf = io.open(f, "rb")
    if f == nil then 
        return false end
    io.close()
    return true
end

local function find_test(f)
    -- if class is Impl, just try without Impl first
    -- if none is found, return without Impl
    local r
    if f:match('Impl%.java$') then
        r = f:gsub("src/main/java", "src/test/java"):gsub("%Impl.java$", "Test.java")
        if is_file_exists(r) then
            return r
        end
    else
        r = f:gsub("src/main/java", "src/test/java"):gsub("%.java$", "Test.java")
    end
    return r
end

local function find_class(f)
    -- look if an Impl exists
    local r = f:gsub("src/test/java", "src/main/java"):gsub("Test%.java", "Impl.java")
    if is_file_exists(r) then
        return r
    end
    local r = f:gsub("src/test/java", "src/main/java"):gsub("Test%.java", ".java")
    if not is_file_exists(r) then
        return nil, "Class not found"
    end
    return r
end

local function vjt()
    local bufnr = api.nvim_get_current_buf()
    local bufname = api.nvim_buf_get_name(bufnr)

    local f, err
    if bufname:match("src/main/java") then
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
