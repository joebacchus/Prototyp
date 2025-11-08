def main [] {

    let $create_location = "~/PhD/experiments" | path expand

    code $"($create_location)/.setup"

    clear

}