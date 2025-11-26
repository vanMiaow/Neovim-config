
-- luasnip
local ls = require("luasnip")
local snippet = ls.snippet
local s = ls.snippet_node
local t = ls.text_node
local i = ls.insert_node
local c = ls.choice_node
local f = ls.function_node
local d = ls.dynamic_node
local ex = require("luasnip.extras")
local r = ex.rep

-- util
local util = require("script.util")
local tofloat = util.tofloat

-- new line
local function crlf()
    return t({ "", "" })
end

-- quoted insert node
local function qi(index, prompt)
    return s(index, { t("'"), i(1, prompt), t("'") })
end

-- formula insert node
-- return caluclated value or default prompt
function fi(index, ref, prompt, f, digit)
    return d(index, function(args)
        local x = tonumber(args[1][1])
        if (not x) then
            return s(nil, i(1, prompt))
        elseif (not f) then
            return s(nil, i(1, args[1][1]))
        else
            return s(nil, i(1, tofloat(f(x), digit)))
        end
    end, ref)
end

-- area to diameter
function a2d(area)
    return 2 * math.sqrt(area / math.pi)
end

-- select CF/TF
local function ct(index, prompt)
    return s(index, { c(1, { t("CF"), t("TF") }), t("  "), qi(2, prompt) })
end

return {
    ---- Melcor Input ----
    snippet({ trig = "PROGRAM", desc = "Melcor Input" }, {
        t("PROGRAM MELGEN"), crlf(),
        crlf(),
        t("EXEC_INPUT"), crlf(),
        t("EXEC_TITLE   "), qi(1, "[TITLE]"), crlf(),
        t("EXEC_TSTART  "), i(2, "0.0"), crlf(),
        t("EXEC_DTTIME  0.1"), crlf(),
        crlf(),
        t("MP_INPUT"), crlf(),
        t("MP_ID  Concrete"), crlf(),
        t("MP_ID  Stainless-Steel"), crlf(),
        crlf(),
        t("NCG_INPUT"), crlf(),
        t("NCG_ID  N2"), crlf(),
        t("NCG_ID  O2"), crlf(),
        crlf(),
        t("CVH_INPUT"), crlf(),
        i(0), crlf(),
        crlf(),
        t("FL_INPUT"), crlf(),
        crlf(),
        t("HS_INPUT"), crlf(),
        crlf(),
        t("CF_INPUT"), crlf(),
        crlf(),
        t("TF_INPUT"), crlf(),
        crlf(),
        t("END PROGRAM MELGEN"), crlf(),
        crlf(),
        t("PROGRAM MELCOR"), crlf(),
        crlf(),
        t("EXEC_INPUT"), crlf(),
        t("EXEC_TITLE  "), r(1), crlf(),
        t("EXEC_TIME  2"), crlf(),
        t("           !  TIME  DTMAX  DTMIN  DTEDT  DTPLT  DTRST"), crlf(),
        t("           1  "), r(2), t("  1.0E-01  1.0E-06  1.0E+03  1.0E-01  1.0E+03"), crlf(),
        t("           2  "), f(function(args)
            local time = tonumber(args[1][1])
            if (time and time >= 0) then
                return tofloat(time + 1)
            else
                return "0.0"
            end
        end, 2), t("  1.0E-01  1.0E-06  1.0E+03  1.0E-01  1.0E+03"), crlf(),
        t("EXEC_TEND  "), i(3, "1000.0"), crlf(),
        t("EXEC_CPULIM   86400.0"), crlf(),
        t("EXEC_CPULEFT  60.0"), crlf(),
        crlf(),
        t("END PROGRAM MELCOR"), crlf()
    }),
    ---- Control Volume ----
    snippet({ trig = "CV_ID", desc = "Control Volume" }, {
        ---- CV_ID ----
        t("CV_ID   "), qi(1, "[NAME]"), t("  "), i(2, "[NO]"), crlf(),
        ---- CV_FLD ----
        t("CV_FLD  "), c(3, { t("Water"), t("LBE") }), crlf(),
        ---- CV_THR ----
        t("CV_THR  NonEquil  Fog  "), c(4, { t("Active"), t("Time-Indep"), t("Prop-Specified") }), crlf(),
        ---- CV_PAS ----
        t("CV_PAS  Separate  "), c(5, { t("PoolAndAtm"), t("OnlyPool"), t("OnlyAtm") }), d(6, function(args)
            if (args[1][1] == "OnlyAtm") then
                return s(nil, t(""))
            else
                return s(nil, { t("  "), c(1, { t("Subcooled"), t("Saturated") }) })
            end
        end, 5), d(7, function(args)
            if (args[1][1] == "OnlyPool") then
                return s(nil, t(""))
            else
                return s(nil, { t("  "), c(1, { t("Superheated"), t("Saturated") }) })
            end
        end, 5), crlf(),
        ---- CV_PTD ----
        t("CV_PTD  PVOL  "), d(8, function(args)
            if (args[1][1] == "Prop-Specified") then
                return s(nil, ct(1, "[PVOL]"))
            else
                return s(nil, i(1, "[PVOL]"))
            end
        end, 4), crlf(),
        ---- CV_PAD ----
        d(9, function(args)
            if (args[1][1] ~= "  Subcooled") then
                return s(nil, t(""))
            elseif (args[2][1] == "Prop-Specified") then
                return s(nil, { t("CV_PAD        "), ct(1, "[TPOL]"), crlf() })
            else
                return s(nil, { t("CV_PAD        "), i(1, "[TPOL]"), crlf() })
            end
        end, { 6, 4 }),
        ---- CV_AAD ----
        d(10, function(args)
            if (args[1][1] ~= "  Superheated") then
                return s(nil, t(""))
            elseif (args[2][1] == "Prop-Specified") then
                return s(nil, { t("CV_AAD  TATM  "), ct(1, "[TATM]"), crlf() })
            else
                return s(nil, { t("CV_AAD  TATM  "), i(1, "[TATM]"), crlf() })
            end
        end, { 7, 4 }),
        ---- CV_NCG ----
        d(11, function(args)
            if (args[1][1] == "OnlyPool") then
                return s(nil, t(""))
            elseif (args[2][1] == "Prop-Specified") then
                return s(nil, { t("CV_NCG  2  PH2O  "), ct(1, "[PH2O]"), crlf(),
                                t("        1   N2   "), ct(2, "[MLFR]"), crlf(),
                                t("        2   O2   "), ct(3, "[MLFR]"), crlf() })
            else
                return s(nil, { t("CV_NCG  2  RHUM  "), i(1, "[RHUM]"), crlf(),
                                t("        1   N2   0.79"), crlf(),
                                t("        2   O2   0.21"), crlf() })
            end
        end, { 5, 4 }),
        ---- CV_BND ----
        d(12, function(args)
            if (args[1][1] ~= "PoolAndAtm") then
                return s(nil, t(""))
            elseif (args[2][1] == "Prop-Specified") then
                return s(nil, { t("CV_BND  ZPOL  "), ct(1, "[ZPOL]"), crlf() })
            else
                return s(nil, { t("CV_BND  ZPOL  "), i(1, "[ZPOL]"), crlf() })
            end
        end, { 5, 4 }),
        ---- CV_VAT ----
        t("CV_VAT  2"), crlf(),
        t("        1  "), i(13, "[ZLW]"), t("  0.0"), crlf(),
        t("        2  "), i(14, "[ZHI]"), t("  "), i(15, "[VOL]")
    }),
    ---- Flow Path ----
    snippet({ trig = "FL_ID", desc = "Flow Path" }, {
        ---- FL_ID ----
        t("FL_ID   "), qi(1, "[NAME]"), t("  "), i(2, "[NO]"), crlf(),
        ---- FL_FT ----
        t("FL_FT   "), qi(3, "[CVFM]"), t("  "), qi(4, "[CVTO]"), t("  "), i(5, "[ZFM]"), t("  "), fi(6, 5, "[ZTO]"), crlf(),
        ---- FL_GEO ----
        t("FL_GEO  "), i(7, "[AREA]"), t("  "), i(8, "[LEN]"), t("  "), i(9, "[OPEN]"), t("  "), fi(10, 7, "[HFM]", a2d, 6), t("  "), fi(11, 7, "[HTO]", a2d, 6), crlf(),
        ---- FL_JSW ----
        t("FL_JSW  "), c(12, { t("0"), t("3") }), t("  NoBubbleRise  NoBubbleRise ! 0-vert 3-horiz"), crlf(),
        ---- FL_USL ----
        t("FL_USL  "), i(13, "[LOSF]"), t("  "), fi(14, 13, "[LOSR]"), crlf(),
        ---- FL_SEG ----
        t("FL_SEG  1"), crlf(),
        t("        1  "), fi(15, 7, "[SARA]"), t("  "), fi(16, 8, "[SLEN]"), t("  "), fi(17, 15, "[SHYD]", a2d, 6)
    }),
    ---- Valve ----
    snippet({ trig = "FL_VLV", desc = "Valve" }, {
        ---- FL_VLV ----
        t("FL_VLV  1"), crlf(),
        t("        1  "), qi(1, "[VLV]"), t("  "), qi(2, "[FL]"), t("  NoTrip  "), qi(3, "[CF]"), t("")
    }),
    ---- Pump ----
    snippet({ trig = "FL_PMP", desc = "Pump" }, {
        ---- FL_PMP ----
        t("FL_PMP  1"), crlf(),
        t("        1  "), qi(1, "[PMP]"), t("  "), qi(2, "[FL]"), t("  Quick-CF  "), qi(3, "[CF]"), t("")
    }),
    ---- Time Dependent Flow Path ----
    snippet({ trig = "FL_VTM", desc = "Time Dependent Flow Path" }, {
        ---- FL_VTM ----
        t("FL_VTM  1"), crlf(),
        t("        1  "), qi(1, "[FL]"), t("  "), ct(2, "[VEL]")
    }),
    ---- Hest Structure ----
    snippet({ trig = "HS_ID", desc = "Heat Structure" }, {
        ---- HS_ID ----
        t("HS_ID   "), qi(1, "[NAME]"), t("  "), i(2, "[NO]"), crlf(),
        ---- HS_GD ----
        t("HS_GD   "), c(3, { t("Rectangular"), t("Cylindrical"), t("Spherical"), t("BottomHalfSphere"), t("TopHalfSphere") }), t("  Yes"), crlf(),
        ---- HS_EOD ----
        t("HS_EOD  "), i(4, "[ALT]"), t("  "), i(5, "[ALP]"), crlf(),
        ---- HS_SRC ----
        t("HS_SRC  "), c(6, { t("No"),  t("CF"), t("TF") }), d(7, function(args)
            if (args[1][1] == "No") then
                return s(nil, t(""))
            else
                return s(nil, { t("  "), qi(1, "[SRC]"), t("  1.0") })
            end
        end, 6), crlf(),
        ---- HS_ND ----
        t("HS_ND   "), i(8, "[NN]"), t("  2"), crlf(),
        t("        1  1  "), i(9, "[XL]"), t("  "), i(10, "[TL]"), t("  "), i(11, "[MAT]"), f(function(args)
            local n = tonumber(args[2][1])
            if (args[1][1] == "No") then
                return ""
            elseif (n and n > 1) then
                return "  " .. tofloat(1 / (n - 1))
            else
                return "  [QFRC]"
            end
        end, { 6, 8 }), crlf(),
        t("        2  "), r(8), t("  "), i(12, "[XR]"), t("  "), fi(13, 10, "[TR]"), crlf(),
        ---- HS_FT ----
        t("HS_FT   Off"), crlf(),
        ---- HS_LB ----
        t("HS_LB   "), c(14, { t("Symmetry"), t("CalcCoefHS"), t("CoefCF"), t("SourCF"), t("FluxCF"), t("TempCF"), t("CoefTimeTF"), t("CoefTempTF"), t("SourTimeTF"), t("FluxTimeTF"), t("TempTimeTF") }), d(15, function(args)
            if (args[1][1]:sub(-2) == "CF") then
                return s(nil, { t("  "), qi(1, "[CF]") })
            elseif (args[1][1]:sub(-2) == "TF") then
                return s(nil, { t("  "), qi(1, "[TF]") })
            else
                return s(nil, t(""))
            end
        end, 14), d(16, function(args)
            if (args[1][1] == "Symmetry" or args[1][1]:sub(1, 4) == "Temp") then
                return s(nil, t(""))
            elseif (args[1][1]:sub(1, 4) == "Flux") then
                return s(nil, { t("  "), c(1, { t("No"), qi(1, "[CV]") }) })
            else
                return s(nil, { t("  "), qi(1, "[CV]") })
            end
        end, 14), d(17, function(args)
            if (args[1][1] == "Symmetry" or args[1][1]:sub(1, 4) == "Temp" or args[1][1]:sub(1, 4) == "Flux") then
                return s(nil, t(""))
            else
                return s(nil, { t("  "), c(1, { t("Yes"), t("No") }) })
            end
        end, 14), crlf(),
        ---- HS_LBP ----
        t("HS_LBP  Int  0.05  0.95"), crlf(),
        ---- HB_LBS ----
        d(18, function(args)
            if (args[1][1] == "" or args[1][1] == "  No") then
                return s(nil, t(""))
            elseif (args[2][1] == "Rectangular") then
                return s(nil, { t("HS_LBS  "), i(1, "[AREA]"), t("  "), i(2, "[CLEN]"), t("  "), i(3, "[ALEN]"), crlf() })
            elseif (args[2][1] == "Cylindrical") then
                return s(nil, { t("HS_LBS  1.0  "), i(1, "[CLEN]"), t("  "), i(2, "[ALEN]"), crlf() })
            else
                return s(nil, { t("HS_LBS  1.0  "), i(1, "[CLEN]"), t("  1.0"), crlf() })
            end
        end, { 16, 3 }),
        ---- HS_RB ----
        t("HS_RB   "), c(19, { t("Symmetry"), t("CalcCoefHS"), t("CoefCF"), t("SourCF"), t("FluxCF"), t("TempCF"), t("CoefTimeTF"), t("CoefTempTF"), t("SourTimeTF"), t("FluxTimeTF"), t("TempTimeTF") }), d(20, function(args)
            if (args[1][1]:sub(-2) == "CF") then
                return s(nil, { t("  "), qi(1, "[CF]") })
            elseif (args[1][1]:sub(-2) == "TF") then
                return s(nil, { t("  "), qi(1, "[TF]") })
            else
                return s(nil, t(""))
            end
        end, 19), d(21, function(args)
            if (args[1][1] == "Symmetry" or args[1][1]:sub(1, 4) == "Temp") then
                return s(nil, t(""))
            elseif (args[1][1]:sub(1, 4) == "Flux") then
                return s(nil, { t("  "), c(1, { t("No"), qi(1, "[CV]") }) })
            else
                return s(nil, { t("  "), qi(1, "[CV]") })
            end
        end, 19), d(22, function(args)
            if (args[1][1] == "Symmetry" or args[1][1]:sub(1, 4) == "Temp" or args[1][1]:sub(1, 4) == "Flux") then
                return s(nil, t(""))
            else
                return s(nil, { t("  "), c(1, { t("Yes"), t("No") }) })
            end
        end, 19), crlf(),
        ---- HS_RBP ----
        t("HS_RBP  Int  0.05  0.95"),
        ---- HB_RBS ----
        d(23, function(args)
            if (args[1][1] == "" or args[1][1] == "  No") then
                return s(nil, t(""))
            elseif (args[2][1] == "Rectangular") then
                return s(nil, { crlf(), t("HS_RBS  "), i(1, "[AREA]"), t("  "), i(2, "[CLEN]"), t("  "), i(3, "[ALEN]") })
            elseif (args[2][1] == "Cylindrical") then
                return s(nil, { crlf(), t("HS_RBS  1.0  "), i(1, "[CLEN]"), t("  "), i(2, "[ALEN]") })
            else
                return s(nil, { crlf(), t("HS_RBS  1.0  "), i(1, "[CLEN]"), t("  1.0") })
            end
        end, { 21, 3 })
    }),
    ---- Control Function ----
    snippet({ trig = "CF_ID", desc = "Control Function" }, {
        ---- CF_ID ----
        t("CF_ID   "), qi(1, "[NAME]"), t("  "), i(2, "[NO]"), t("  "), c(3, { t("Equals"), t("Tab-Fun"), t("Add"), t("Multiply"), t("Divide"), t("Formula"), t("Equals ! Const"), t("SignI ! Open-At"), t("SignI ! Close-At") }), crlf(),
        ---- CF_SAI ----
        t("CF_SAI  "), d(4, function(args)
            if (args[1][1] == "Equals ! Const") then
                return s(nil, { t("0.0  "), i(1, "[CONST]"), t("  "), r(1) })
            elseif (args[1][1] == "SignI ! Open-At") then
                return s(nil, t("-0.5  0.5  0.0"))
            elseif (args[1][1] == "SignI ! Close-At") then
                return s(nil, t("0.5  0.5  1.0"))
            else
                return s(nil, { i(1, "[SCAL]"), t("  "), i(2, "[ADCN]"), t("  "), i(3, "[INIT]") })
            end
        end, 3), crlf(),
        ---- CF_MSC ----
        d(5, function(args)
            if (args[1][1] ~= "Tab-Fun") then
                return s(nil, t(""))
            else
                return s(nil, { t("CF_MSC  "), i(1, "[TF]"), crlf() })
            end
        end, 3),
        ---- CF_ARG ----
        d(6, function(args)
            if (args[1][1] == "Formula") then
                return s(nil, t(""))
            elseif (args[1][1] == "Equals ! Const") then
                return s(nil, { t("CF_ARG  1"), crlf(),
                                t("        1  EXEC-TIME  0.0  0.0") })
            elseif (args[1][1] == "SignI ! Open-At" or args[1][1] == "SignI ! Close-At") then
                return s(nil, { t("CF_ARG  1"), crlf(),
                                t("        1  EXEC-TIME  -1.0  "), i(1, "[TIME]") })
            elseif (args[1][1] == "Equals" or args[1][1] == "Tab-Fun") then
                return s(nil, { t("CF_ARG  1"), crlf(),
                                t("        1  "), i(1, "[ARG]"), t("  "), i(2, "[SCAL]"), t("  "), i(3, "[ADCN]") })
            else
                return s(nil, { t("CF_ARG  2"), crlf(),
                                t("        1  "), i(1, "[ARG]"), t("  "), i(2, "[SCAL]"), t("  "), i(3, "[ADCN]"), crlf(),
                                t("        2  "), i(4, "[ARG]"), t("  "), i(5, "[SCAL]"), t("  "), i(6, "[ADCN]") })
            end
        end, 3),
        ---- CF_FORMULA ----
        d(7, function(args)
            if (args[1][1] ~= "Formula") then
                return s(nil, t(""))
            else
                return s(nil, { t("CF_FORMULA  3  "), qi(1, "[FORMULA]"), crlf(),
                                t("            1  "), i(2, "[X]"), t("  "), i(3, "[ARG]"), crlf(),
                                t("            2  "), i(4, "[Y]"), t("  "), i(5, "[ARG]"), crlf(),
                                t("            3  "), i(6, "[Z]"), t("  "), i(7, "[ARG]") })
            end
        end, 3)
    }),
    ---- Tabular Function ----
    snippet({ trig = "TF_ID", desc = "Tabular Function" }, {
        ---- TF_ID ----
        t("TF_ID   "), qi(1, "[NAME]"), t("  "), i(2, "[SCAL]"), t("  "), i(3, "[ADCN]"), crlf(),
        ---- TF_TAB ----
        t("TF_TAB  1"), crlf(), t("        1  "), i(4, "[X]"), t("  "), i(5, "[Y]")
    })
}

