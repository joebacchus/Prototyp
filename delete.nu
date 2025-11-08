def main [experiment_name: string] {

    let $create_location = "~/PhD/experiments" | path expand
    let $experiment_file = $"($create_location)/($experiment_name)" | path expand

    gh repo delete $experiment_name 
    rm -rf $experiment_file 
    
    clear

}