class Agent
{
    PVector position;
    PVector velocity;
    PVector acceleration;
    
    Brain brain;
    
    int radius;
    
    Environment environment;
    
    double currentDistance;
    double lastDistance;
    
    Agent(Environment environment)
    {
        this.environment = environment;
        
        position = new PVector((environment.upperBound.x - environment.lowerBound.x) / 2 + environment.lowerBound.x,(environment.upperBound.y - environment.lowerBound.y) / 2 + environment.lowerBound.y);
        velocity = new PVector(random( -1, 1),(random( -1, 1)));
        acceleration = new PVector(random( -1, 1),(random( -1, 1)));
        
        radius = 80;
        
        brain = new Brain(100);
        
        lastDistance = 0;
    }
    
    Agent(Environment environment, Brain brain)
    {
        this.environment = environment;
        
        position = new PVector((environment.upperBound.x - environment.lowerBound.x) / 2 + environment.lowerBound.x,(environment.upperBound.y - environment.lowerBound.y) / 2 + environment.lowerBound.y);
        velocity = new PVector(random( -1, 1),(random( -1, 1)));
        acceleration = new PVector(random( -1, 1),(random( -1, 1)));
        
        radius = 80;
        
        this.brain = new Brain(brain);
        lastDistance = 0;
    }
    
    void update()
    {
        if (brain.isAlive)
        {
            acceleration = brain.fetchMove();
            
            velocity.x += acceleration.x;
            velocity.y += acceleration.y;
            if (velocity.mag() > 10)
                velocity.setMag(10);
            
            position.x += velocity.x;
            position.y += velocity.y;
            
            if (environment.bounded)
                keepInBounds();
            
            getScore();
            // if (!brain.isAlive)
            // {
            //     if (environment.list_of_targets.size() == 0 || brain.currentTarget >= environment.list_of_targets.size())
            //     {
            //         Target currentTarget = environment.list_of_targets.get(brain.currentTarget);
            //         double distance = dist(position.x, position.y, currentTarget.position.x, currentTarget.position.y);
            //         brain.fitness -= distance;
            //     }
            // }
        }
    }
    void keepInBounds()
    {
        //for collision with the left and right walls
        if (position.x < environment.lowerBound.x + radius)
        {
            position.x = environment.lowerBound.x + radius;
            velocity.x *= -1;
        }
        if (position.x > environment.upperBound.x - radius)
        {
            position.x = environment.upperBound.x - radius;
            velocity.x *= -1;
        }
        
        //for collision with the top and bottom walls
        if (position.y < environment.lowerBound.y + radius)
        {
            position.y = environment.lowerBound.y + radius;
            velocity.y *= -1;
        }
        if (position.y > environment.upperBound.y - radius)
        {
            position.y = environment.upperBound.y - radius;
            velocity.y *= -1;
        }
    }
    
    void getScore()
    {
        if (environment.list_of_targets.size() == 0 || brain.currentTarget >= environment.list_of_targets.size())
            return;
        
        Target currentTarget = environment.list_of_targets.get(brain.currentTarget);
        double distance = dist(position.x, position.y, currentTarget.position.x, currentTarget.position.y);
        
        if (distance < currentTarget.radius)
        {
            brain.currentTarget++;
            brain.addRandom(50);
            brain.totalMoves += 50;
            brain.reward += 1000;
        }
        
        double delta = lastDistance - currentDistance; // (+) - getting close || (-) - getting away
        if (delta > 0)
            brain.reward += delta/10.0;
        // if (delta < 0)
        //     brain.penalty -= delta/10.0;
        
        lastDistance = currentDistance;
        currentDistance = distance;
    }
    
    void show()
    {
        circle(position.x, position.y, radius);
    }
}
