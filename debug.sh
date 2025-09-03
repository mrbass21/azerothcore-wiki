#!/bin/sh

# Initialize empty arrays
locales=()
paths=()

echo "Parsing _config.yml to discover locales..."

# Extract locale and path pairs from the file
echo "Locales and paths found:"
current_locale=""
while IFS= read -r line; do
    # Check if this line contains a locale definition
    if [[ $line =~ ^[[:space:]]*locale:[[:space:]]*\"([^\"]+)\" ]]; then
        current_locale="${BASH_REMATCH[1]}"
    # Check if this line contains a path definition
    elif [[ $line =~ ^[[:space:]]*path:[[:space:]]*\"([^\"]+)\" ]]; then
        path="${BASH_REMATCH[1]}"
        # Only add to arrays if we have a current locale
        if [ -n "$current_locale" ]; then
            echo "  Adding pair: $current_locale -> $path"
            locales+=("$current_locale")
            paths+=("$path")
        else
            echo "  Skipping path (no current locale)"
        fi
    # Reset current_locale when we encounter a new section
    elif [[ $line =~ ^[[:space:]]*[^[:space:]] ]]; then
        # This is a new section, reset current locale
        current_locale=""
    fi
done < _config.yml

echo "Found the folowing locales: ${locales[*]}"

# Show how to use them
if [ ${#locales[@]} -gt 0 ]; then
    echo ""
    echo "Accessing values:"
    for i in "${!locales[@]}"; do
        echo "  locales[$i] = ${locales[$i]}"
        echo "  paths[$i] = ${paths[$i]}"
    done
fi

# Get a list of all changed documents, unique filenames only
changed_doc_files=$(git diff --name-only 40ab830ff9217c6515d6a639e99ecb5f2d654073...8a92f8f4263e69ef20ca616038f62637fb94357c | grep "^docs/")

temp_array=()
while IFS= read -r file; do
    temp_array+=("$(basename "$file")")
done <<< "$changed_doc_files"

printf '%s\n' "${temp_array[@]}" | sort | uniq | while read -r filename; do
    for i in "${!locales[@]}"; do
        echo "Checking if ${paths[$i]}/$filename exists:"
        if [ -f "${paths[$i]}/$filename" ]; then
            
            target_file="docs/en/example.md"
            if ! echo "$changed_doc_files" | grep -q "^${paths[$i]}/$filename$"; then
                # A locale file exists for an edited document, but the locale is missing changes
                echo "File ${paths[$i]}/$filename is missing changes!"
            fi
        fi
    done
done


# # Get list of sorted locales from the _config.yml file
# locales=$(grep -A 10 -B 2 "defaults:" _config.yml | grep "locale:" | sed 's/.*locale:[ "]*//' | sed 's/[",]*$//')
# IFS=$'\n'; locales=($locales); unset IFS;  # split the string into an array

# # Get a list of all changed documents, unique filenames only (so we don't have to parse every locale of file changed)
# #changed_doc_files=$(git diff --name-only origin/$GITHUB_BASE_REF...${{ github.sha }} | grep "^docs/")
# changed_doc_files=$(git diff --name-only 40ab830ff9217c6515d6a639e99ecb5f2d654073...8a92f8f4263e69ef20ca616038f62637fb94357c | grep "^docs/")

# # Create an array to track filenames we've already seen
# seen_filenames=("")
# echo "$changed_doc_files" | while read -r file; do
#     # Extract just the filename (basename)
#     filename=$(basename "$file")
    
#     # Check if we've seen this filename before
#     if ! echo "$seen_filenames" | grep -q "^$filename$"; then
#         echo "Processing: $file"
#         echo "File: $filename"
#         seen_filenames+=("$filename")
#     else
#         echo "Skipping duplicate filename: $file"
#     fi
# done


# printf "%s\n Files seen\n" "${seen_filenames[@]}"
#IFS=$'\n';seen_filenames=($seen_filenames); unset IFS;  # split the string into an array


# for changedFile in "${seen_filenames[@]}"; do
#     # Make sure we have a change in all supported locales for the changed file
#     echo $changedFile
# done

# exit

# new_doc_files=$(git diff --name-only --diff-filter=A origin/$GITHUB_BASE_REF...${{ github.sha }} | grep "^docs/")
# deleted_files=$(git diff --name-only --diff-filter=D origin/$GITHUB_BASE_REF...${{ github.sha }} | grep "^docs/")
# IFS=$'\n'; files=($files); unset IFS;  # split the string into an array\

# # New for loop to iterate over the $files variable
# echo "Iterating over changed files:"
# for file in "${files[@]}"; do
#     echo "Processing changed file: $file"


# done

# for locale in $locales; do
#     echo "Checking locale: $locale"
    
#     # Find files in /docs folder with matching locale
#     find docs -type f -name "*.$locale" | while read -r file; do
#         echo "Found file: $file"
        
#         # Check if file has changes in git
#         if git diff --exit-code "$file" > /dev/null 2>&1; then
#             echo "  No changes in git for $file"
#         else
#             echo "  File $file has changes in git"
#         fi
#     done
# done