
-- luasnip
local ls = require("luasnip")
local snippet = ls.snippet
local t = ls.text_node
local i = ls.insert_node
local c = ls.choice_node
local s = ls.snippet_node
local f = ls.function_node
local d = ls.dynamic_node
local ex = require("luasnip.extras")
local l = ex.lambda
local m = ex.match
local r = ex.rep
local k = require("luasnip.nodes.key_indexer").new_key

-- util
local util = require("script.util")
local trim = util.trim
local tofloat = util.tofloat
local contains = util.contains

-- new line
local function crlf()
    return t({ "", "" })
end

-- condition node
-- return node true or false based on condition
local function condition_node(index, key_str, node_ref, condition, node_true, node_false)
    return d(index, function(args)
        if (condition(args)) then
            return s(nil, node_true)
        else
            return s(nil, node_false or t(""))
        end
    end, node_ref, { key = key_str })
end

-- formula insert node
-- return caluclated value or default prompt
function formula_insert(index, key_str, node_ref, prompt, f, digit)
    return d(index, function(args)
        local x = tonumber(args[1][1])
        if (x) then
            if (f) then
                return s(nil, i(1, tofloat(f(x), digit)))
            else
                return s(nil, i(1, args[1][1]))
            end
        else
            return s(nil, i(1, prompt))
        end
    end, node_ref, { key = key_str })
end

-- quoted insert node
local function quoted_insert(index, key_str, prompt)
    return s(index, { t("'"), i(1, prompt), t("'") }, { key = key_str })
end

-- select CF/TF input
local function select_cftf(index, key_str, prompt)
    return c(index, { { t("CF  "), quoted_insert(1, nil, prompt) }, { t("TF  "), quoted_insert(1, nil, prompt) } }, { key = key_str })
end

-- select control volume variable input
local function select_variable(index, prompt)
    return d(index, function(args)
        if (args[1][1] == "Prop-Specified") then
            return s(nil, select_cftf(1, nil, prompt))
        else
            return s(nil, i(1, prompt))
        end
    end, k("ActiveSwitch"))
end

return {
    ---- Melcor Input ----
    snippet({ trig = "PROGRAM", desc = "Melcor Input" }, {
        t({ "PROGRAM MELGEN",
            "",
            "EXEC_INPUT",
            "EXEC_TITLE   " }), quoted_insert(1, "Title", "[TITLE]"), t({ "",
            "EXEC_TSTART  " }), i(2, "0.0", { key = "TimeStart" }), t({ "",
            "EXEC_DTTIME  0.1",
            "",
            "MP_INPUT",
            "MP_ID  Concrete",
            "MP_ID  Stainless-Steel",
            "",
            "NCG_INPUT",
            "NCG_ID  N2",
            "NCG_ID  O2",
            "",
            "CVH_INPUT",
            "" }), i(0), t({ "",
            "",
            "FL_INPUT",
            "",
            "HS_INPUT",
            "",
            "CF_INPUT",
            "",
            "TF_INPUT",
            "",
            "END PROGRAM MELGEN",
            "",
            "PROGRAM MELGEN",
            "",
            "EXEC_INPUT",
            "EXEC_TITLE  " }), r(k("Title")), t({ "",
            "EXEC_TIME  2",
            "           !  TIME  DTMAX  DTMIN  DTEDT  DTPLT  DTRST",
            "           1  " }), r(k("TimeStart")), t({ "  1.0E-01  1.0E-06  1.0E+03  1.0E-01  1.0E+03",
            "           2  " }), m(k("TimeStart"), function(args) local ts = tonumber(args[1][1]) return (ts and ts < 0) end, "0.0", "1.0"), t({ "  1.0E-01  1.0E-06  1.0E+03  1.0E-01  1.0E+03",
            "EXEC_TEND  " }), i(3, "1000.0"), t({ "",
            "EXEC_CPULIM   86400.0",
            "EXEC_CPULEFT  60.0",
            "",
            "END PROGRAM MELCOR" })
    }),
    ---- Control Volume ----
    snippet({ trig = "CV_ID", desc = "Control Volume" }, {
        ---- CV_ID ----
        t("CV_ID   "), quoted_insert(1, nil, "[NAME]"), t("  "), i(2, "[NO]"), crlf(),
        ---- CV_FLD ----
        t("CV_FLD  "), c(3, { t("Water"), t("LBE") }), crlf(),
        ---- CV_THR ----
        t("CV_THR  NonEquil  Fog  "), c(4, { t("Active"), t("Time-Indep"), t("Prop-Specified") }, { key = "ActiveSwitch" }), crlf(),
        ---- CV_PAS ----
        t("CV_PAS  Separate  "), c(5, { t("OnlyPool"), t("OnlyAtm"), t("PoolAndAtm") }, { key = "PhaseSwitch" }),
        condition_node(6, nil, k("PhaseSwitch"), function(args) return (args[1][1] ~= "OnlyAtm") end, { t("  "), c(1, { t("Subcooled"), t("Saturated") }, { key = "WaterState" }) }, t("", { key = "WaterState" })),
        condition_node(7, nil, k("PhaseSwitch"), function(args) return (args[1][1] ~= "OnlyPool") end, { t("  "), c(1, { t("Superheated"), t("Saturated") }, { key = "VaporState" }) }, t("", { key = "VaporState" })),
        crlf(),
        ---- CV_PTD ----
        t("CV_PTD  PVOL  "), select_variable(8, "[PVOL]"), crlf(),
        ---- CV_PAD ----
        d(9, function(args)
            if (args[1][1] == "Subcooled") then
                return s(nil, { t("CV_PAD        "), select_variable(1, "[TPOL]"), crlf() })
            else
                return s(nil, t(""))
            end
        end, k("WaterState")),
        ---- CV_AAD & CV_NCG ----
        d(10, function(args)
            if (args[1][1] == "Superheated") then
                if (args[2][1] == "Prop-Specified") then
                    return s(nil, {
                        t("CV_AAD  TATM  "), select_cftf(1, nil, "[TATM]"), crlf(),
                        t("CV_NCG  2  PH2O  "), select_cftf(2, nil, "[PH2O]"), crlf(),
                        t("        1   N2   "), select_cftf(3, nil, "[MLFR]"), crlf(),
                        t("        2   O2   "), select_cftf(4, nil, "[MLFR]"), crlf()
                    })
                else
                    return s(nil, {
                        t("CV_AAD  TATM  "), i(1, "[TATM]"), crlf(),
                        t("CV_NCG  2  RHUM  "), i(2, "[RHUM]"), crlf(),
                        t("        1   N2   0.79"), crlf(),
                        t("        2   O2   0.21"), crlf()
                    })
                end
            else
                return s(nil, t(""))
            end
        end, { k("VaporState"), k("ActiveSwitch") }),
        ---- CV_BND ----
        d(11, function(args)
            if (args[1][1] == "PoolAndAtm") then
                return s(nil, { t("CV_BND  ZPOL  "), select_variable(1, "[ZPOL]"), crlf() })
            else
                return s(nil, t(""))
            end
        end, k("PhaseSwitch")),
        ---- CV_VAT ----
        t("CV_VAT  2"), crlf(),
        t("        1  "), i(12, "[ZLW]"), t("  0.0"), crlf(),
        t("        2  "), i(13, "[ZHI]"), t("  "), i(14, "[VOL]")
    }),
    ---- Flow Path ----
    snippet({ trig = "FL_ID", desc = "Flow Path" }, {
        ---- FL_ID ----
        t("FL_ID   "), quoted_insert(1, nil, "[NAME]"), t("  "), i(2, "[NO]"), crlf(),
        ---- FL_FT ----
        t("FL_FT   "), quoted_insert(3, nil, "[CVFM]"), t("  "), quoted_insert(4, nil, "[CVTO]"), t("  "), i(5, "[ZFM]", { key = "ZFrom" }), t("  "), formula_insert(6, nil, k("ZFrom"), "[ZTO]"), crlf(),
        ---- FL_GEO ----
        t("FL_GEO  "), i(7, "[AREA]", { key = "Area" }), t("  "), i(8, "[LEN]", { key = "Length" }), t("  "), i(9, "[OPEN]"), t("  "),
        formula_insert(10, "HeightFrom", k("Area"), "[HFM]", function(x) return (2 * math.sqrt(x / math.pi)) end, 6), t("  "),
        formula_insert(11, nil, k("HeightFrom"), "[HTO]"), crlf(),
        ---- FL_JSW ----
        t("FL_JSW  "), c(12, { t("0"), t("3") }), t("  NoBubbleRise  NoBubbleRise ! 0-vert 3-horiz"), crlf(),
        ---- FL_USL ----
        t("FL_USL  "), i(13, "[LOSF]", { key = "LossForward" }), t("  "), formula_insert(14, nil, k("LossForward"), "[LOSR]"), crlf(),
        ---- FL_SEG ----
        t("FL_SEG  1"), crlf(),
        t("        1  "),
        formula_insert(15, "SegmentArea", k("Area"), "[SARA]"), t("  "),
        formula_insert(16, nil, k("Length"), "[SLEN]"), t("  "),
        formula_insert(17, nil, k("SegmentArea"), "[SHYD]", function(x) return (2 * math.sqrt(x / math.pi)) end, 6)
    }),
    ---- Valve ----
    snippet({ trig = "FL_VLV", desc = "Valve" }, {
        ---- FL_VLV ----
        t("FL_VLV  1"), crlf(),
        t("        1  "), quoted_insert(1, nil, "[VLV]"), t("  "), quoted_insert(2, nil, "[FL]"), t("  NoTrip  "), quoted_insert(3, nil, "[CF]"), t("")
    }),
    ---- Pump ----
    snippet({ trig = "FL_PMP", desc = "Pump" }, {
        ---- FL_PMP ----
        t("FL_PMP  1"), crlf(),
        t("        1  "), quoted_insert(1, nil, "[PMP]"), t("  "), quoted_insert(2, nil, "[FL]"), t("  Quick-CF  "), quoted_insert(3, nil, "[CF]"), t("")
    }),
    ---- Time Dependent Flow Path ----
    snippet({ trig = "FL_VTM", desc = "Time Dependent Flow Path" }, {
        ---- FL_VTM ----
        t("FL_VTM  1"), crlf(),
        t("        1  "), quoted_insert(1, nil, "[FL]"), t("  "), select_cftf(2, nil, "[VEL]")
    }),
    ---- Hest Structure ----
    snippet({ trig = "HS_ID", desc = "Heat Structure" }, {
        ---- HS_ID ----
        t("HS_ID   "), quoted_insert(1, nil, "[NAME]"), t("  "), i(2, "[NO]"), crlf(),
        ---- HS_GD ----
        t("HS_GD   "), c(3, { t("Rectangular"), t("Cylindrical"), t("Spherical"), t("BottomHalfSphere"), t("TopHalfSphere") }, { key = "Geometry" }), t("  Yes"), crlf(),
        ---- HS_EOD ----
        t("HS_EOD  "), i(4, "[ALT]"), t("  "), i(5, "[ALP]"), crlf(),
        ---- HS_SRC ----
        t("HS_SRC  "),
        c(6, {
            t("No"),
            { t("CF"), t("  "), quoted_insert(1, nil, "[SRC]"), t("  1.0") },
            { t("TF"), t("  "), quoted_insert(1, nil, "[SRC]"), t("  1.0") }
        }, { key = "SourceType" }), crlf(),
        ---- HS_ND ----
        t("HS_ND   "), i(7, "[NN]", { key = "NumberNodes" }), t("  2"), crlf(),
        t("        1  1  "), i(8, "[XL]"), t("  "), i(9, "[TL]", { key = "TemperatureLeft" }), t("  "), i(10, "[MAT]"),
        f(function(args)
            if (args[1][1] == "No") then
                return ""
            else
                local n = tonumber(args[2][1])
                if (n and n > 1) then
                    return "  " .. tofloat(1 / (n - 1))
                else
                    return "  [NaN]"
                end
            end
        end, { k("SourceType"), k("NumberNodes") }), crlf(),
        t("        2  "), r(k("NumberNodes")), t("  "), i(11, "[XR]"), t("  "), formula_insert(12, nil, k("TemperatureLeft"), "[TR]"), crlf(),
        ---- HS_FT ----
        t("HS_FT   Off"), crlf(),
        ---- HS_LB ----
        t("HS_LB   "),
        c(13, { t("Symmetry"), t("CalcCoefHS"), t("CoefCF"), t("SourCF"), t("FluxCF"), t("TempCF"), t("CoefTimeTF"), t("CoefTempTF"), t("SourTimeTF"), t("FluxTimeTF"), t("TempTimeTF") }, { key = "LeftBoundaryCondition" }),
        d(14, function(args)
            if (args[1][1]:sub(-2) == "CF") then
                return s(nil, { t("  "), i(1, "[CF]") })
            elseif (args[1][1]:sub(-2) == "TF") then
                return s(nil, { t("  "), i(1, "[TF]") })
            else
                return s(nil, t(""))
            end
        end, k("LeftBoundaryCondition")),
        d(15, function(args)
            if (contains({ "Symmetry", "TempCF", "TempTimeTF" }, args[1][1])) then
                return s(nil, t(""))
            elseif (contains({ "FluxCF", "FluxTimeTF" }, args[1][1])) then
                return s(nil, { t("  "), c(1, { t("No"), i(1, "[CV]") }) })
            else
                return s(nil, { t("  "), i(1, "[CV]") })
            end
        end, k("LeftBoundaryCondition"), { key = "LeftBoundaryVolume" }),
        condition_node(16, nil, k("LeftBoundaryCondition"), function(args) return (contains({ "CalcCoefHS", "CoefCF", "SourCF", "CoefTimeTF", "CoefTempTF", "SourTimeTF" }, args[1][1])) end, { t("  "), c(1, { t("Yes"), t("No") }) }), crlf(),
        ---- HS_LBP ----
        t("HS_LBP  Int  0.05  0.95"), crlf(),
        ---- HB_LBS ----
        d(17, function(args)
            if (contains({ "", "  No" }, args[1][1])) then
                return s(nil, t(""))
            elseif (args[2][1] == "Rectangular") then
                return s(nil, { t("HS_LBS  "), i(1, "[AREA]"), t("  "), i(2, "[CLEN]"), t("  "), i(3, "[ALEN]"), crlf() })
            else
                return s(nil, { t("HS_LBS  1.0  "), i(1, "[CLEN]"), t("  "), i(2, "[ALEN]"), crlf() })
            end
        end, { k("LeftBoundaryVolume"), k("Geometry") }),
        ---- HS_RB ----
        t("HS_RB   "),
        c(18, { t("Symmetry"), t("CalcCoefHS"), t("CoefCF"), t("SourCF"), t("FluxCF"), t("TempCF"), t("CoefTimeTF"), t("CoefTempTF"), t("SourTimeTF"), t("FluxTimeTF"), t("TempTimeTF") }, { key = "RightBoundaryCondition" }),
        d(19, function(args)
            if (args[1][1]:sub(-2) == "CF") then
                return s(nil, { t("  "), i(1, "[CF]") })
            elseif (args[1][1]:sub(-2) == "TF") then
                return s(nil, { t("  "), i(1, "[TF]") })
            else
                return s(nil, t(""))
            end
        end, k("RightBoundaryCondition")),
        d(20, function(args)
            if (contains({ "Symmetry", "TempCF", "TempTimeTF" }, args[1][1])) then
                return s(nil, t(""))
            elseif (contains({ "FluxCF", "FluxTimeTF" }, args[1][1])) then
                return s(nil, { t("  "), c(1, { t("No"), i(1, "[CV]") }) })
            else
                return s(nil, { t("  "), i(1, "[CV]") })
            end
        end, k("RightBoundaryCondition"), { key = "RightBoundaryVolume" }),
        condition_node(21, nil, k("RightBoundaryCondition"), function(args) return (contains({ "CalcCoefHS", "CoefCF", "SourCF", "CoefTimeTF", "CoefTempTF", "SourTimeTF" }, args[1][1])) end, { t("  "), c(1, { t("Yes"), t("No") }) }), crlf(),
        ---- HS_RBP ----
        t("HS_RBP  Ext  0.05  0.95"), crlf(),
        ---- HB_LBS ----
        d(22, function(args)
            if (contains({ "", "  No" }, args[1][1])) then
                return s(nil, t(""))
            elseif (args[2][1] == "Rectangular") then
                return s(nil, { t("HS_RBS  "), i(1, "[AREA]"), t("  "), i(2, "[CLEN]"), t("  "), i(3, "[ALEN]") })
            else
                return s(nil, { t("HS_RBS  1.0  "), i(1, "[CLEN]"), t("  "), i(2, "[ALEN]") })
            end
        end, { k("RightBoundaryVolume"), k("Geometry") })
    }),
    ---- Control Function ----
    snippet({ trig = "CF_ID", desc = "Control Function" }, {
        ---- CF_ID ----
        t("CF_ID   "), quoted_insert(1, nil, "[NAME]"), t("  "), i(2, "[NO]"), t("  "),
        c(3, { t("Equals"), t("Tab-Fun"), t("Add"), t("Multiply"), t("Divide"), t("Formula"), t("Equals ! Const"), t("SignI ! Open-At"), t("SignI ! Close-At") }, { key = "Type" }), crlf(),
        ---- CF_SAI ----
        d(4, function(args)
            if (args[1][1] == "Equals ! Const") then
                return s(nil, { t("CF_SAI  0.0  "), i(1, "[CONST]", { key = "Constant" }), t("  "), r(k("Constant")) })
            elseif (args[1][1] == "SignI ! Open-At") then
                return s(nil, { t("CF_SAI  -0.5  0.5  0.0") })
            elseif (args[1][1] == "SignI ! Close-At") then
                return s(nil, { t("CF_SAI  0.5  0.5  1.0") })
            else
                return s(nil, { t("CF_SAI  "), i(1, "[SCAL]"), t("  "), i(2, "[ADCN]"), t("  "), i(3, "[INIT]") })
            end
        end, k("Type")), crlf(),
        ---- CF_MSC ----
        condition_node(5, nil, k("Type"), function(args) return (args[1][1] == "Tab-Fun") end, { t("CF_MSC  "), i(1, "[TF]"), crlf() }),
        ---- CF_ARG ----
        d(6, function(args)
            if (args[1][1] == "Equals ! Const") then
                return s(nil, { t("CF_ARG  1"), crlf(), t("        1  EXEC-TIME  0.0  0.0") })
            elseif (args[1][1] == "SignI ! Open-At" or args[1][1] == "SignI ! Close-At") then
                return s(nil, { t("CF_ARG  1"), crlf(), t("        1  EXEC-TIME  -1.0  "), i(1, "[TIME]") })
            elseif (args[1][1] == "Formula") then
                return s(nil, t(""))
            elseif (args[1][1] == "Equals" or args[1][1] == "Tab-Fun") then
                return s(nil, { t("CF_ARG  1"), crlf(), t("        1  "), i(1, "[ARG]"), t("  "), i(2, "[SCAL]"), t("  "), i(3, "[ADCN]") })
            else
                return s(nil, { t("CF_ARG  2"), crlf(), t("        1  "), i(1, "[ARG]"), t("  "), i(2, "[SCAL]"), t("  "), i(3, "[ADCN]"), crlf(), t("        2  "), i(4, "[ARG]"), t("  "), i(5, "[SCAL]"), t("  "), i(6, "[ADCN]") })
            end
        end, k("Type")),
        ---- CF_FORMULA ----
        condition_node(7, nil, k("Type"), function (args) return (args[1][1] == "Formula") end, {
            t("CF_FORMULA  3  "), quoted_insert(1, nil, "[FORMULA]"), crlf(),
            t("            1  "), i(2, "[X]"), t("  "), i(3, "[ARG]"), crlf(),
            t("            2  "), i(4, "[Y]"), t("  "), i(5, "[ARG]"), crlf(),
            t("            3  "), i(6, "[Z]"), t("  "), i(7, "[ARG]")
        })
    }),
    ---- Tabular Function ----
    snippet({ trig = "TF_ID", desc = "Tabular Function" }, {
        ---- TF_ID ----
        t("TF_ID   "), quoted_insert(1, nil, "[NAME]"), t("  "), i(2, "[SCAL]"), t("  "), i(3, "[ADCN]"), crlf(),
        ---- TF_TAB ----
        t("TF_TAB  1"), crlf(), t("        1  "), i(4, "[X]"), t("  "), i(5, "[Y]")
    })
}

