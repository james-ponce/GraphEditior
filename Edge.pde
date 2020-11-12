// Class that represents each edge
public enum Directed{NONE, POS1, POS2};

class Edge{
    private float _posX1, _posY1, _posX2, _posY2;
    private int _offset;
    private Directed direction;
    private Node _n1, _n2;

    Edge(float x1, float y1, float x2, float y2){
        _posX1 = x1;
        _posX2 = x2;
        _posY1 = y1;
        _posY2 = y2;
        direction = Directed.NONE;
        _n1 = null;
        _n2 = null;
        _offset = 0;
    }

    Edge(Node n1, Node n2){
        _posX1 = n1.getPositionX();
        _posY1 = n1.getPositionY();
        _posX2 = n1.getPositionX();
        _posY2 = n1.getPositionY();
        direction = Directed.NONE;
        _n1 = n1;
        _n2 = n2;
        _offset = 0;
    }

    public void setPosOne(float x1, float y1){
        _posX1 = x1;
        _posY1 = y1;
    }

    public void setPosTwo(float x2, float y2){
        _posX2 = x2;
        _posY2 = y2;
    }

    public void setEndPoints(Node n1, Node n2){
        _n1 = n1;
        _n2 = n2;
    }

    public void setOffset(int offset){
        _offset = offset;
    }

    public void update(){
        if(_n1 != null && _n2 != null){
            _posX1 = _n1.getPositionX();
            _posY1 = _n1.getPositionY();
            _posX2 = _n2.getPositionX();
            _posY2 = _n2.getPositionY();

            computeOffSet();
        }
    }

    public float[] getPosOne(){
        return new float[] {_posX1, _posY1};
    }

    public Node getPosOneNode(){
        return _n1;
    }

    public float[] getPosTwo(){
        return new float[] {_posX2, _posY2};
    }

    public Node getPosTwoNode(){
        return _n2;
    }

    public void remove(Node removed){

        if(_n1 == _n2){
            return;
        }

        if(_n1 == removed){
            _n2.getList().remove(this);
            _n2 = null;
        }
        else{
            _n1.getList().remove(this);
            _n1 = null;
        }
        
    }

    public boolean containsNode(Node node){
        return (node == _n1) || (node == _n2);
    }

    public void display(){
        line(_posX1, _posY1, _posX2, _posY2);
    }

    private void computeOffSet(){
        float ratio = (_posX2-_posX1)/(_posY2-_posY1);
        float angle = atan(ratio);

        _posX1 += ((_offset) * cos(angle));
        _posY1 += ((_offset) * -sin(angle));
        _posX2 += ((_offset) * cos(angle));
        _posY2 += ((_offset) * -sin(angle));

        //println("(" + _posX1, _posY1 + ")");
    }
}
