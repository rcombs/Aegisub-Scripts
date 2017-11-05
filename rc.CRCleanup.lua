script_name="CR Cleanup"
script_description="Flattens CR scripts"
script_author="rcombs"
script_version="1.0.0"
script_namespace="rc.CRCleanup"

local haveDepCtrl,DependencyControl,depRec=pcall(require,"l0.DependencyControl")
if haveDepCtrl then
  depRec = DependencyControl{feed="https://raw.githubusercontent.com/rcombs/Aegisub-Scripts/master/DependencyControl.json"}
end

function cleanup(subs,sel,act)
    aegisub.progress.title("Flattening CR styles")

    map = {}
    for i = 1, #subs do
        aegisub.progress.set(i / #subs)
        line = subs[i]
        if subs[i].class == "style" then
            if not line.name:match("sign_") then
                map[line.name] = line
            end
        end

        if subs[i].class == "dialogue" then
            st = map[line.style]
            if st ~= nil then
                line.style = "Default"
                if st.italic then
                    line.text = "{\\i1}" .. line.text
                end
                if not st.align == 2 then
                    line.text = "{\\an" .. st.align .. "}" .. line.text
                end
                subs[i] = line
            end
        end
    end

    aegisub.set_undo_point(script_name)
end

if haveDepCtrl then depRec:registerMacro(cleanup) else aegisub.register_macro(script_name,script_description,cleanup) end
