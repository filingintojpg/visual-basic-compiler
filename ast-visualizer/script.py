import sys
import pprint

def find_nth(string, substr, n):
    index = string.find(substr, n)
    for i in range(n-1):
        index = string.find(substr, index+1)
    return index

def create_token(id, token_type, token_value):
    return {"id": id, "node_type": "token", "type": token_type, "value": token_value}

def create_nterm(id, nterm_type, nodes):
    return {"id": id, "node_type": "nterm", "type": nterm_type, "nodes": nodes}

def print_parse_tree(root):
    print("digraph {")
    print_parse_node(root)
    print("}")

def print_parse_node(node):
    if node["node_type"] == "token":
        if node["value"]:
            label_str = f"{node['type']} [{node['value']}]"
        else:
            label_str = f"{node['type']}"

        label_str = label_str.replace('"', '\\"')
        print(f"{node['id']} [label=\"{label_str}\"];")

    elif node["node_type"] == "nterm":
        print(f"{node['id']} [label={node['type']}];")
        for child in node["nodes"]:
            print_parse_node(child)
            print(f"{node['id']} -> {child['id']};")

def is_nterm_reduce_string(line):
    i = 0
    while line[i] == " ":
        i += 1
    return line[i] == "$"

if len(sys.argv) != 2:
    print("Program usage: python ast-visualizer.py <bison debug info file>.", file=sys.stderr)
    sys.exit(1)

lines = []
with open(sys.argv[1], encoding="utf-8") as file:
    lines = file.read().split("\n")

stack = []
i = 0
while i < len(lines):
    line = lines[i]

    if line.startswith("Shifting"):
        components = line.split(" ")

        value_i = find_nth(line, " ", 3)
        value = line[value_i+2:]
        if value[-1] == ")":
            value = value[:-1]
        else:
            i += 1
            line = lines[i]
            while not line.endswith("\")"):
                value += "\n" + line
                i += 1
                line = lines[i]
            value += "\n" + line[:-1]

        token_name = components[2]
        stack.append(create_token(i, token_name, value))

    elif line.startswith("Reducing"):
        i += 1
        nterm_rule_size = 0
        while not lines[i].startswith("->"):
            if is_nterm_reduce_string(lines[i]):
                nterm_rule_size += 1
            i += 1

        components = lines[i].split(" ")
        nterm_name = components[4]
        nterm_body = []
        if nterm_rule_size != 0:
            nterm_body = stack[-nterm_rule_size:]
            stack = stack[:-nterm_rule_size]

        nterm = create_nterm(i, nterm_name, nterm_body)
        stack.append(nterm)

    elif line.startswith("syntax"):
        components = lines[i].split(" ")
        stack.append(create_token(i, f"UNEXPECTED {components[3][:-1]}, EXPECTING {components[5]}", ""))
        nterm = create_nterm(i+1, "\"SYNTAX ERROR IN PROGRAM\"", stack)
        stack = [nterm]

    i += 1

print_parse_tree(stack[0])
