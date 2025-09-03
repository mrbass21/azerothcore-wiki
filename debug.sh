#!/bin/sh

# Store results in an array
IFS=$'\n' read -d '' -r -a result_array < <(grep -A 10 -B 2 "locale:" _config.yml | grep -E "(locale|path|permalink)" | head -20)

# Now you can access individual elements
echo "First element: ${result_array[0]}"
echo "All elements:"
printf '%s\n' "${result_array[@]}"

exit

# # Get a list of all changed documents, unique filenames only
# changed_doc_files=$(git diff --name-only 40ab830ff9217c6515d6a639e99ecb5f2d654073...8a92f8f4263e69ef20ca616038f62637fb94357c | grep "^docs/")

# # Simple approach - just process the files and show what we'd process
# echo "Changed doc files:"
# echo "$changed_doc_files"

# temp_array=()
# while IFS= read -r file; do
#     temp_array+=("$(basename "$file")")
# done <<< "$changed_doc_files"

# printf '%s\n' "${temp_array[@]}" | sort | uniq | while read -r filename; do
#     echo "Unique: $filename"
# done


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