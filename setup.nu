def main [experiment_name: string] {

    let $user_name = "joebacchus"
    let $create_location = "~/PhD/experiments" | path expand
    let $experiment_file = $"($create_location)/($experiment_name)" | path expand

    if ($experiment_file | path exists) {
        code $"($experiment_file)/configs/default.code-workspace"
    } else {

    figlet -c -f roman Proto
    figlet -c -f roman typ

    cp -r $"($create_location)/.setup/template" $"($create_location)"
    mv $"($create_location)/template" $"($experiment_file)" 
    # date now | format date "%Y-%m-%d %H:%M:%S" | save $"($experiment_file)/workspace/notes.typ" --append

    cd $experiment_file
    
    pixi init
    pixi add ipykernel numpy matplotlib scienceplots pandas pytorch networkx

    jj git init 
    jj describe -m "init"
    jj bookmark create "main"

    gh repo create $experiment_name --private
    jj git remote add $experiment_name $"https://github.com/($user_name)/($experiment_name).git"
    jj git push --remote $experiment_name --bookmark "main" --allow-new

    code $"($experiment_file)/configs/default.code-workspace"

    clear

    }

}