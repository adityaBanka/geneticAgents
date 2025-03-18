class Target
{
    PVector position;
    int radius = 100;

    Target(PVector position)
    {
        this.position = new PVector(position.x, position.y);
    }
    void show(int counter)
    {
        textSize(20);
        text(counter, position.x, position.y);
        circle(position.x, position.y, radius);
    }
}
