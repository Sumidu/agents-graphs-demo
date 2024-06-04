# main file
using Pkg
Pkg.activate(".")

using Agents
using Graphs
using Random
using GraphPlot
using Compose

@agent struct DemoAgent(ContinuousAgent{2,Float64}) # inherit all properties of `GridAgent{2}`
   infected::Int64
end

function agent_step!()
end


function init(seed=123, spacing=1.0, agent_count=20)

    g = Graph()
    model = StandardABM(
        DemoAgent,
        ContinuousSpace((100, 100); spacing=spacing, periodic=false);
        agent_step!,
        properties = Dict(
            :friends => g
        ),
        rng = MersenneTwister(seed)
    )

    for i in 1:agent_count
        p = DemoAgent(i, (0.0, 0.0), (0.0, 0.0), 0)
        add_agent!(p, model)
        add_vertex!(g)
        if i > 1
            for i in 1:rand(1:5)
                otheragent = random_agent(model)
                if otheragent.id != i
                    add_edge!(model.friends, i, otheragent.id)
                end
            end
        end
    end

    return model
end

model = init()

gplot(model.friends)
model.friends

draw(PNG("test.png", 16cm, 16cm), gplot(model.friends))


# if agent 1 and 2 want to become friends
add_edge!(model.friends, 1, 2)
add_edge!(model.friends, 1, 3)
add_edge!(model.friends, 2, 5)
add_edge!(model.friends, 5, 4)
#remove_edge!(model.friends, 1, 2)
add_edge!(model.friends, 1, 5)


# get friends of an agent
nbs = neighbors(model.friends, 4)
nbs_agents = [model[i] for i in nbs]

