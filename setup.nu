def main [
    command_name?: string
    experiment_name?: string
    --paper (-p)
    --light (-l)
    ] {
    let $proto_loc = "~/Documents/prototyp" | path expand
    let $create_location = $env.PWD | path expand
    # let $user_name = open "~/Documents/prototyp/configs.json" | get username
    let $user_name = "joebacchus"

    if ($command_name == null and $experiment_name == null) {
        pwd
        code $proto_loc

    } else if ($command_name == "add" and $experiment_name != null) {

        let $experiment_file = $"($create_location)/($experiment_name)" | path expand
        let $workspace_file = "default.code-workspace"
        # figlet -c -f roman Proto

        cp -r $"($proto_loc)/template" $"($experiment_file)"
        
        # date now | format date "%Y-%m-%d %H:%M:%S" | save $"($experiment_file)/workspace/notes.typ" --append

        cd $experiment_file 

        pixi init
        if ($light) {
            pixi add ipykernel numpy matplotlib scienceplots pandas networkx scipy tqdm
        } else {
            pixi add ipykernel numpy matplotlib scienceplots pandas networkx scipy tqdm 
        }
        if ($paper) {

            echo "paper = true" | save configs/info.toml
            
            cd codebase
            jj git init 
            jj describe -m "Init Codebase."
            jj bookmark create "main"

            gh repo create $experiment_name --private
            jj git remote add $experiment_name $"https://github.com/($user_name)/($experiment_name).git"
            jj git push --remote $experiment_name --bookmark "main" --allow-new

            cd ..

            cd paper

            start https://www.overleaf.com/project

            let token = (input token:)

            jj git init
            jj bookmark create "master"
            git add .
            git commit -m "Local Init."
            git branch -M master
            git remote add overleaf $"https://git@git.overleaf.com/($token)"
            git fetch overleaf master

            git merge overleaf/master --allow-unrelated-histories -m "Overleaf Master."

            rm main.tex
            git push overleaf master --set-upstream
            jj bookmark track master@overleaf
            
            jj describe @ -m "Init Paper."
            jj bookmark move master
            jj git push -b master

        } else {
            echo "paper = false" | save configs/info.toml
            rm -rf codebase
            rm -rf paper
        }

        print $"Succesfully added project ($experiment_name) for ($user_name)"

        code $"($experiment_file)/configs/($workspace_file)"

    } else if ($command_name == "remove" and $experiment_name != null) {
        
        let $experiment_file = $"($create_location)/($experiment_name)" | path expand

        if (open $"($experiment_file)/configs/info.toml" | get paper) {
            gh repo delete $experiment_name 
        }

        rm -rf $experiment_file 

        print $"Succesfully removed project ($experiment_name) for ($user_name)"
        
    }

    }
