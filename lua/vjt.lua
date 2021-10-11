--[===[
Jump between class and test
--]===]
local do_test = false


local api = vim.api

local function is_file_exists(f)
    local cf = io.open(f, "rb")
    if cf == nil then 
        return false end
    io.close(cf)
    return true
end

local function find_test(f)
    local f = f
    -- if class is Impl, just try without Impl first
    -- if none is found, return without Impl
    local r
    if f:match('Impl%.java$') then
        local rs, ref
        -- try to find a test ending with Impl first
        rs = f:gsub("src/main/java", "src/test/java"):gsub("Impl.java$", "ImplTest.java")
        ref = rs
        -- then without Impl if not found
        if not is_file_exists(rs) then
            rs = f:gsub("src/main/java", "src/test/java"):gsub("Impl.java$", "Test.java")
        end
        -- or with the prefix I and without Impl and /impl/
        if not is_file_exists(rs) then
            rs = f:gsub("src/main/java", "src/test/java")
                :gsub("/impl/","/")
                :gsub("Impl.java$", "Test.java")
                :gsub("/([^/]+%.java)$","/I%1")
        end
        -- then based on the assumed interface name
        if not is_file_exists(rs) then
            rs = f:gsub("src/main/java", "src/test/java"):gsub("/impl/","/"):gsub("Impl.java$", "Test.java")
        end
        r = ref
    else
        r = f:gsub("src/main/java", "src/test/java"):gsub("%.java$", "Test.java")
    end
    return r
end

local function find_class(f)
    -- look if an Impl exists first
    --local r = f:gsub("src/test/java", "src/main/java"):gsub("ImplTest%.java", "Test.java"):gsub("Test%.java", "Impl.java")
    local r = f:gsub("src/test/java", "src/main/java"):gsub("ImplTest%.java", "Test.java"):gsub("Test%.java", "Impl.java"):gsub("/I([^/]+%.java)$","/%1")
    -- or try with the prefix I
    if not is_file_exists(r) then
        r = f:gsub("src/test/java", "src/main/java"):gsub("ImplTest%.java", "Test.java"):gsub("Test%.java", "Impl.java")
    end
    if not is_file_exists(r) then
        local i = r:gsub("src/main/java", "src/test/java"):match('^.*()/')
        r = r:sub(1,i) .. "impl" .. r:sub(i) or nil
        r = is_file_exists(r) and r or nil
    end
    r = r or f:gsub("src/test/java", "src/main/java"):gsub("Test%.java", ".java")
    if not is_file_exists(r) then
        return nil, "Class not found"
    end
    return r
end
-- find class interface
local function find_interface(f)
    -- TODO
end

-- find class interface when in test
local function find_interface_from_test(f)
    -- TODO
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
