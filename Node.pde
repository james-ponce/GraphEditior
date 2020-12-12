//Class that represents all nodes.
import java.util.Map;

public class Node{
    private float _posX, _posY;
    private float _size;
    private ArrayList<Edge> _edges;
    private HashMap<Node, Integer>_edgeCount;

    private int _r, _g, _b;

    Node(float x, float y){
        _posX = x;
        _posY = y;
        _size = 50;
        _edges = new ArrayList<Edge>();
        _edgeCount = new HashMap<Node, Integer>();
    }

    Node(float x, float y, float size){
        _posX = x;
        _posY = y;
        _size = size;
        _edges = new ArrayList<Edge>();
        _edgeCount = new HashMap<Node, Integer>();
    }
    
    public void setFill(int r, int g, int b){
        _r = r;
        _g = g;
        _b = b;
    }

    public void setPosition(float x, float y){
        _posX = x;
        _posY = y;
    }

    public float getPositionX(){
        return _posX;
    }

    public float getPositionY(){
        return _posY;
    }

    public float getRadius(){
        return _size/2;
    }

    public float getCenterX(){
        return _posX;
    }

    public float getCenterY(){
        return _posY;
    }

    public ArrayList<Edge> getList(){
        return _edges;
    }

    public void addEdge(Edge e){
        boolean check;
        Node endNode;

        _edges.add(e);
        if (e.getPosOneNode() == e.getPosTwoNode()){
            handleLoops(e.getPosOneNode());
            return;
        }

        if(e.getPosOneNode() != this){
            check = _edgeCount.containsKey(e.getPosOneNode());
            endNode = e.getPosOneNode();
        }
        else{
            check = _edgeCount.containsKey(e.getPosTwoNode());
            endNode = e.getPosTwoNode();
        }

        if(check){
            Integer count = _edgeCount.get(endNode);
            _edgeCount.put(endNode, count+1);

            
                handleParralelEdges(endNode);
        
            
        }
        else{
            _edgeCount.put(endNode, 1);
        }
    }

    public void removeEdge(Edge e){
        Node endNode;
        boolean check;

        println("removing edge");
        if (e.getPosOneNode() == e.getPosTwoNode()){
            handleLoops(e.getPosOneNode());
            return;
        }

        println("checking for parrallel");
        if(e.getPosOneNode() != this){
            check = _edgeCount.containsKey(e.getPosOneNode());
            endNode = e.getPosOneNode();
        }
        else{
            check = _edgeCount.containsKey(e.getPosTwoNode());
            endNode = e.getPosTwoNode();
        }

        if(check){
            Integer count = _edgeCount.get(endNode);
            handleParralelEdges(endNode);
        }
        
        

    }

    private void handleLoops(Node base){
        int offset = 0;
        println("handling loops");

        for(Edge e: _edges){
            if (e.getPosOneNode() == base && e.getPosTwoNode() == base){
                e.setOffset(offset);
                offset += 5;
            }
        }
    }

    private void handleParralelEdges(Node end){
        println("parrallel");
        boolean oddCount = ((_edgeCount.get(end) % 2) == 1);
        int offset = oddCount?0:5;

        for(Edge e: _edges){
            if (e.getPosOneNode() == end || e.getPosTwoNode() == end){
                //println(offset);
                e.setOffset(offset);

                switch(offset){
                    case 0: 
                        offset = 10;
                    break;
                    default :
                        offset = abs(offset)!=offset?((offset-10) * -1):(offset*-1);
                    break;	
                }
                //println(offset);
            }
        }
    }

    public boolean clicked(float x, float y){

        float distance = sqrt(pow((_posX-x), 2) + pow((_posY-y), 2));
        return (distance < (_size/2));
        
    }

    public void displayEdge(){
        for(Edge e: _edges){
            e.update();
            e.display();
        }
    }

    public void display(){
        fill(_r, _g, _b);
        
        ellipse(_posX, _posY, _size, _size);

        fill(255);
        text(_edges.size(), _posX-2, _posY);
    }
}
