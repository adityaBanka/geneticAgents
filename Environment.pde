class Environment
{
    int padding;
    PVector size_of_window;
    public PVector lowerBound;
    public PVector upperBound;
    boolean bounded;
    
    int population;
    ArrayList<Agent> list_of_agents;
    ArrayList<Target> list_of_targets;
    
    Brain fittestReward;
    Brain fittestPenalty;

    int generation = 1;
    
    Environment(int population, int padding, boolean bounded)
    {
        this.population = population;
        this.padding = padding;
        this.bounded = bounded;
        
        lowerBound = new PVector(padding, padding);
        upperBound = new PVector(width - padding, height - padding);
        
        list_of_agents = new ArrayList<Agent>();
        for (int i = 0; i < population; i++)
        {
            list_of_agents.add(new Agent(this));
        }
        
        list_of_targets = new ArrayList<Target>();
    }
    
    void update()
    {
        for (Agent agent : list_of_agents)
        {
            agent.update();
        }
        int aliveCount = getAliveCount();
        if (aliveCount == list_of_agents.size())
        {
            generation++;
            fittestReward = fittestBrainReward();
            fittestPenalty = fittestBrainPenalty();
            Brain fittest = new Brain(fittestReward, fittestPenalty);
            fittest = fittestBrainFitness();
            
            list_of_agents = new ArrayList<Agent>();
            System.out.println(fittest.reward);
            for (int i = 0; i < population; i++)
            {
                list_of_agents.add(new Agent(this, fittestReward));
            }
            for(int i = 1; i<population; i++)
            {
                list_of_agents.get(i).brain.mutate(generation/10, 1);
            }
        }
    }
    
    int getAliveCount()
    {
        int count = 0;
        for (Agent agent : list_of_agents)
        {
            if (!agent.brain.isAlive)
                count++;
        }
        return(count);
    }
    
    Brain fittestBrainReward()
    {
        Brain fittest = (list_of_agents.get(0)).brain;
        if(fittestReward != null)
        fittest = fittestReward;

        for (Agent agent : list_of_agents)
        {
            if (agent.brain.reward > fittest.reward)
                fittest = agent.brain;
        }
        return(fittest);
    }
    
    Brain fittestBrainPenalty()
    {
        Brain fittest = (list_of_agents.get(0)).brain;
        for (Agent agent : list_of_agents)
        {
            if (agent.brain.penalty < fittest.penalty)
                fittest = agent.brain;
        }
        return(fittest);
    }

    Brain fittestBrainFitness()
    {
        Brain fittest = (list_of_agents.get(0)).brain;

        for (Agent agent : list_of_agents)
        {
            if (agent.brain.fitness > fittest.fitness)
                fittest = agent.brain;
        }
        return(fittest);
    }


    void show()
    {
        if(bounded)
        {
            noFill();
            stroke(255);
            strokeWeight(2);
            rect(lowerBound.x, lowerBound.y, upperBound.x - lowerBound.x, upperBound.y - lowerBound.y, 50);
        }
        //rect(lowerBound.x - padding, lowerBound.y - padding, upperBound.x - lowerBound.x + 2*padding, upperBound.y - lowerBound.y + 2*padding, 50);
        
        noStroke();
        fill(#d3d3d3, 64);
        for (Agent agent : list_of_agents)
        {
            agent.show();
        }
        
        fill(#f55f79, 192);
        int counter = 1;
        for (Target target : list_of_targets)
        {
            target.show(counter++);
        }
    }
    
}
