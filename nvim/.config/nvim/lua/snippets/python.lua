local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node
local f = ls.function_node

return {
    s({trig = "pvar", descr="Expands to print(f\"var: {var}\")"},
        {
            t("print(f\""),
            i(1, "var"),
            t(": {"),
            f(function(args)
                return args[1]
            end, {1}),
            t("}\")")
        }
    )
}
