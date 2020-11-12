ArrayList<Node> list = new ArrayList<Node>();
ArrayList<Edge> edgeList = new ArrayList<Edge>();
Edge tempEdge = null; // An edge just meant represent a new edge until the edge is committed to nodes.
Node tempNode = null;
Node selectedNode = null;
void setup (){
    size(640,640);
    background(255);
    //noStroke();
}

void draw (){
    background(255);
    fill(255);
    textSize(20);

    for (Node x: list){
        strokeWeight(3);
        x.displayEdge();
    }

    for (Node x: list){
        strokeWeight(0);
        x.display();
    }

    if (tempEdge != null){
        strokeWeight(1);
        tempEdge.display();
    }

    String info = "n=" + list.size() + " m=" + edgeList.size();

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
                return;
            }
        }

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
    }
        
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
                selectedNode.getList().remove(found);
                if(loop)
                    selectedNode.getList().remove(found);
            }
        }
    }
    
}

void mousePressed(){
    if (mouseButton == LEFT){
        for (Node node: list){
            if (node.clicked(mouseX, mouseY)){
                
                if(tempEdge == null)
                    tempEdge = new Edge(mouseX, mouseY, mouseX, mouseY);

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
        tempNode.setPosition((float)mouseX, (float)mouseY);
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

    for (Node node: list){
        float centerX = node.getCenterX(), centerY = node.getCenterY();
        float distance = sqrt(pow((centerX-tempEdge.getPosOne()[0]), 2) + pow((centerY-tempEdge.getPosOne()[1]), 2));
        if (distance < node.getRadius()){
            head = node;
        }
        
        distance = sqrt(pow((centerX-tempEdge.getPosTwo()[0]), 2) + pow((centerY-tempEdge.getPosTwo()[1]), 2));
        if (distance < node.getRadius()){
            tail = node;
        }

        if (head != null && tail != null){
            break;
        }
    }

    if (head != null && tail != null){
        
        tempEdge.setEndPoints(head, tail);

        head.addEdge(tempEdge);
        tail.addEdge(tempEdge);
        edgeList.add(tempEdge);

        tempEdge.update();
    }
    tempEdge = null;
}
