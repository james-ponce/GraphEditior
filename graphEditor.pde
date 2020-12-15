import java.util.Map;
import java.util.Stack;
import java.util.Queue;
import java.util.LinkedList;

ArrayList<Node> list = new ArrayList<Node>();
ArrayList<Edge> edgeList = new ArrayList<Edge>();
Edge tempEdge = null; // An edge just meant represent a new edge until the edge is committed to nodes.
Node tempNode = null;
Node selectedNode = null;
boolean colorMode = false;
boolean labelMode = false;
boolean snappingMode = false;
int snapDistance = 25;

int[][] colorList = {{35,194,66},{29,80,205},{239,125,102}, {61,135,184}};

void setup (){
    size(1020,1020);
    background(255);
    //noStroke();
}

void draw (){
    background(255);
    fill(255);
    textSize(20);
    findBridges();

    int label = 1;

    if (snappingMode){
        fill(125);
        for(int i = 0; i < height/snapDistance; i++){
            line(0, snapDistance*i, width, snapDistance*i);
        }
        for(int i = 0; i < width/snapDistance; i++){
            line(snapDistance*i, 0, snapDistance*i, height);
        }
    }

    for (Node x: list){
        strokeWeight(3);
        x.displayEdge();
    }

    for (Node x: list){

        if(labelMode){
            strokeWeight(0);
            x.display(label++);
        }
        else{
            strokeWeight(0);
            x.display();
        }
        
    }

    if (tempEdge != null){
        strokeWeight(1);
        tempEdge.display();
    }

    int minColoring = minimalColoring();
    int components = computeComponents();

    String info = "n=" + list.size() + " m=" + edgeList.size() + " components=" + components+ "minimal coloring="+ minColoring + " bipartite= " + ((minColoring == 2 && components == 1)? "true" : "false");

    fill(0);
    textSize(32);
    text(info, 10,30);
}

void mouseClicked(){
    if (mouseButton == LEFT){
        for (Node node: list){

            float centerX = node.getCenterX(), centerY = node.getCenterY();

            float distance = sqrt(pow((centerX-mouseX), 2) + pow((centerY-mouseY), 2));
            if (distance < node.getRadius()){
                return; //<>// //<>//
            } //<>// //<>//
        } //<>// //<>//

        list.add(new Node(mouseX, mouseY));
    }
    if (mouseButton == RIGHT){ //<>//
        for(Node node: list){ //<>//
            if (node.clicked(mouseX, mouseY)){ //<>//
                if(node != selectedNode && selectedNode != null){
                    selectedNode.setFill(0,0,0);
                    selectedNode = node;
                    node.setFill(168, 125,125);
                }
                else if(node != selectedNode){
                    selectedNode = node;
                    node.setFill(168, 125,125);
                }
            }
        }
    } //<>// //<>//
         //<>// //<>//
}

void keyPressed(){
    if (key == DELETE){
        for (Node node: list){ //<>//
            if (node.clicked(mouseX, mouseY)){ //<>//

                for(Edge edge: node.getList()){
                    edgeList.remove(edge);
                    edge.remove(node);
                }

                list.remove(node);

                return;
            }
            else if (selectedNode != null){
                for(Edge edge: selectedNode.getList()){
                    edgeList.remove(edge);
                    edge.remove(node);
                }

                list.remove(selectedNode);
                selectedNode = null;

                return;
            }
        }
    }
    else if (key == BACKSPACE){
        Node oppositeNode = null;
        for(Node checkNode: list){
            if (checkNode.clicked(mouseX, mouseY)){
                oppositeNode = checkNode;
            }
        }

        if (selectedNode != null){
            Edge found = null;
            boolean loop = false;
            for (Edge toRemove: selectedNode.getList()){
                if (toRemove.containsNode(oppositeNode)){
                    loop = (toRemove.getPosOneNode() == toRemove.getPosTwoNode());
                    if (selectedNode == oppositeNode) {
                        if (loop) {
                            edgeList.remove(toRemove);
                            toRemove.remove(selectedNode);
                            found = toRemove;
                            break;
                        }
                    }
                    else{
                        edgeList.remove(toRemove);
                        toRemove.remove(selectedNode);
                        found = toRemove;
                        break;
                    }
                    
                }
            }

            if (found != null){
                selectedNode.removeEdge(found);
                selectedNode.getList().remove(found);
                if(loop)
                    selectedNode.getList().remove(found);
            }
        }
    }
    else if(key == 'c'){
        colorMode = !colorMode;
    }

    else if(key == 'l'){
        labelMode = !labelMode;
    }
    else if(key == 's'){
        if (!snappingMode){
            snappingMode = true;
            snapDistance = 25;
        }
        else{
            if (snapDistance == 200){
                snappingMode = false;
                snapDistance = 25;
            }
            else{
                snapDistance*=2;
            }
        }
    }
    
}

void mousePressed(){
    if (mouseButton == LEFT){
        for (Node node: list){
            if (node.clicked(mouseX, mouseY)){
                
                if(tempEdge == null)
                    tempEdge = new Edge(node);

                return;
            }
        }
    }
    else{
        for(Node node: list){
            
            if (node.clicked(mouseX, mouseY)){
                
                tempNode = node;

                return;
            }
        }
    }
    
}

void mouseDragged() {
    if (tempEdge != null){
        tempEdge.setPosTwo(mouseX, mouseY);
    }
    else if (tempNode != null){
        if (snappingMode){
            int blockX = mouseX/snapDistance, blockY = mouseY/snapDistance, snapX = mouseX%snapDistance, snapY = mouseY%snapDistance;

            if(snapX < snapDistance/2){
                blockX *= snapDistance;
            }
            else{
                blockX = blockX*snapDistance + snapDistance;
            }
            if(snapY < snapDistance/2){
                blockY *= snapDistance;
            }
            else{
                blockY = blockY*snapDistance + snapDistance;
            }

            tempNode.setPosition((float)(blockX), (float)(blockY));
        }
        else{
            tempNode.setPosition((float)mouseX, (float)mouseY);
        }
    }
    
}

void mouseReleased() {
    
    if(tempNode != null){
        tempNode = null;
        return;
    }
    else if (tempEdge == null){
        return;
    }

    Node head = null, tail = null;

    for (Node node: list){;
        if (node.clicked(tempEdge.getPosOne()[0], tempEdge.getPosOne()[1])){
            head = node;
        }
        
        if (node.clicked(tempEdge.getPosTwo()[0], tempEdge.getPosTwo()[1])){
            tail = node;
        }

        if (head != null && tail != null){
            break;
        }
    }

    if (head != null && tail != null){
        println(head, tail);
        
        Edge newEdge = new Edge(head, tail);

        head.addEdge(newEdge);
        tail.addEdge(newEdge);
        edgeList.add(newEdge);

        tempEdge.update();
    }
    tempEdge = null;
}

public int computeComponents(){

    int[][] adjacencyMatrix = new int[list.size()][list.size()];
    int[][] searched = new int[list.size()][list.size()];

    HashMap<Node,Integer> nodes = new HashMap<Node,Integer>();
    HashMap<Integer,Node> reverseNodes = new HashMap<Integer,Node>();
    HashMap<Node, Integer> visited = new HashMap<Node,Integer>();

    int components = 0;

    for (int i = 0; i < list.size(); i++){
        nodes.put(list.get(i), i);
        reverseNodes.put(i, list.get(i));
    }

    for (Edge e: edgeList){
        adjacencyMatrix[nodes.get(e.getPosOneNode())][nodes.get(e.getPosTwoNode())] += 1;
        adjacencyMatrix[nodes.get(e.getPosTwoNode())][nodes.get(e.getPosOneNode())] += 1;
    }

    Stack<Integer> stack =new Stack<Integer>();

    for(Node node: list){
        Integer nodeI = nodes.get(node);
    
        stack.push(nodeI);

        if(visited.containsKey(node)){
            continue;
        }

        while(stack.size() > 0){
            boolean pushed = false;
            for(int i = 0; i < list.size() && !pushed; i++){
                boolean adjacencyFound = adjacencyMatrix[stack.peek()][i] > 0;
                boolean notSearched = searched[stack.peek()][i] == 0;
                
                if (adjacencyFound && notSearched){
                    searched[stack.peek()][i] = 1;
                    visited.put(reverseNodes.get(i), 1);
                    stack.push(i);
                    pushed = true;
                }
            }

            if (!pushed){
                stack.pop();
            }
        }
        components++;
    }

    return components;
}


public int DFS(Node n, Edge e){
    HashMap<Edge,Integer> visited = new HashMap<Edge,Integer>();

    Stack<Node> stack = new Stack<Node>();

    visited.put(e, 1);

    Node nextNode = e.getPosOneNode() == n? e.getPosTwoNode() : e.getPosOneNode();
    stack.push(nextNode);
    boolean moved = false;
    while (!stack.isEmpty()){
        for(Edge path: nextNode.getList()){
            if (visited.containsKey(path)){
                continue;
            }

            nextNode = path.getPosOneNode() == stack.peek() ? path.getPosTwoNode() : path.getPosOneNode();
            visited.put(path, 1);
            stack.push(nextNode);
            moved = true;

            if (nextNode == n){
                return 1;
            }
            
            break;

        }

        if(!moved){
            stack.pop();
            if(!stack.isEmpty()){nextNode = stack.peek();}
        }
        else{
            moved = false;
        }
        
        
    }

    return 0;

}

public void findBridges(){

    for (Node n : list){
        ArrayList<Edge> nEdgeList = n.getList();
        

        for (Edge e: nEdgeList){
            if (DFS(n,e) == 1) 
            {
                
                e.setFill(0);
            }
            else{
                e.setFill(255, 0, 0);
            }
        }

    }
}

public int minimalColoring(){
    int colors = 0;
    
    HashMap<Node, Integer> coloring = new HashMap<Node, Integer>();
    Queue<Node> queue = new LinkedList<Node>();

    for(Node node: list){
        if (coloring.containsKey(node) && coloring.get(node) != 0){
            continue;
        }

        coloring.put(node, 0);
        queue.add(node);
        while(queue.peek()!= null){ //<>//
          
            Node current = queue.remove();
            if(coloring.get(current) != 0){
                println("value ",coloring.get(current));
                continue;
            }
            
            HashMap<Integer, Node> connectedColors = new HashMap<Integer, Node>(); //<>//
            for (Edge e: current.getList()){
                Node opposite = (e.getPosOneNode() == current?e.getPosTwoNode():e.getPosOneNode());
                if (coloring.containsKey(opposite)){
                    connectedColors.put(coloring.get(opposite), null);
                    continue; //<>//
                }
                else{
                    queue.add(opposite);
                    coloring.put(opposite, 0);
                }
            }
            
            int testColor = 1;
            boolean placed = false;
            while(true){
                if (connectedColors.containsKey(testColor)){
                    testColor++;
                }
                else{
                    if (testColor > colors){
                        colors = testColor;
                    }
                    if(colorMode && testColor-1 < colorList.length){
                        int r = colorList[testColor-1][0];
                        int g = colorList[testColor-1][1];
                        int b = colorList[testColor-1][2];
                        current.setFill(r,g,b);
                    }
                    else{
                        current.setFill(0);
                    }
                    coloring.put(current, testColor);
                    break;
                }
            }
        }
        
        

        
    }


    return colors;
}
