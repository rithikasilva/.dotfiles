local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node
local f = ls.function_node

local function get_git_username()
  local handle = io.popen("git config user.name")
  if handle then
    local result = handle:read("*a")
    handle:close()
    return result:gsub("%s+$", "")
  else
    return nil
  end
end

return {
    s({trig = "TODO", descr="// TODO: (git username)"},
        {
            t("// TODO: ("),
            f(get_git_username, {}),
            t(") "),
            i(1, "var"),
        }
    ),
    s({trig = "FIX", descr="// FIX: (git username)"},
        {
            t("// FIX: ("),
            f(get_git_username, {}),
            t(") "),
            i(1, "var"),
        }
    ),
    s({trig = "NOTE", descr="// NOTE: (git username)"},
        {
            t("// NOTE: ("),
            f(get_git_username, {}),
            t(") "),
            i(1, "var"),
        }
    ),
}
