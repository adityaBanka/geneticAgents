import java.util.*;

Environment environment;
boolean live = true;
int simulationRate = 1;
void setup() {
    //size(800, 800);
    fullScreen();
    scale(10.0);
    environment = new Environment(1000, 100, false);
    addTargets();
}

void draw() {
    background(#13171c);
    if (live)
    {
        for(int i = 0; i<simulationRate; i++)
        {
            environment.update();
        }
    }
    environment.show();
}

void addTargets()
{
  PVector center = new PVector(width/2, height/2);
  for(int i = 0; i<360; i+=60)
  {
    PVector tag = PVector.fromAngle(radians(i));
    tag.setMag(400);
    tag.x += center.x;
    tag.y += center.y;
    environment.list_of_targets.add(new Target(tag));
  }
}

void mouseClicked()
{
    if (mouseButton == LEFT)
    {
        environment.list_of_targets.add(new Target(new PVector(mouseX, mouseY)));
    }
    else if (mouseButton == RIGHT)
    {
        for (int i = environment.list_of_targets.size() - 1; i >= 0; i--)
        {
            Target target = environment.list_of_targets.get(i);
            double distance = dist(target.position.x, target.position.y, mouseX, mouseY);
            if (distance <= target.radius)
            {
                environment.list_of_targets.remove(i);
            }
        }
    }
}

void keyReleased() {
    if(key == ' ')  //play or pause - space
    {
        live = !live;
    }
    if(key == CODED)
    {
        if(keyCode == LEFT && simulationRate > 1) //slow down - left
        simulationRate /= 2;
        if(keyCode == RIGHT && simulationRate < 32) //fast forward - right
        simulationRate *= 2;
    }
    if(key == 'r' || key == 'R')    // reset - r
    environment = new Environment(1000, 100, true);
}
