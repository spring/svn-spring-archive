using System;
using System.Collections.Generic;
using System.Text;

namespace MapDesigner
{
    // queue of commands, threadsafe, for comms between ui thread and opengl thread
    class UICommandQueue
    {
        public delegate void UICommandHandler( UICommand command );

        static UICommandQueue instance = new UICommandQueue();
        public static UICommandQueue GetInstance() { return instance; }

        Queue<UICommand> commandlist = new Queue<UICommand>();

        // call from any thread, doesnt do anything
        UICommandQueue()
        {
        }

        // init from glthread
        public void InitFromGlThread()
        {
            RendererFactory.GetInstance().Tick += new TickHandler(UICommandQueue_Tick);
        }

        // glthread only
        void UICommandQueue_Tick()
        {
            lock (commandlist)
            {
                while (commandlist.Count > 0)
                {
                    UICommand command = commandlist.Dequeue();
                    if (consumersbycommand.ContainsKey(command.GetType()))
                    {
                        foreach (UICommandHandler handler in consumersbycommand[command.GetType()])
                        {
                            handler(command);
                        }
                    }
                }
            }
        }

        // ui thread only
        public void Enqueue( UICommand command )
        {
            lock (commandlist)
            {
                commandlist.Enqueue(command);
            }
        }

        Dictionary<Type, List<UICommandHandler>> consumersbycommand = new Dictionary<Type, List<UICommandHandler>>();

        // glthread only
        public void RegisterConsumer(Type commandtype, UICommandHandler handler)
        {
            if (!consumersbycommand.ContainsKey(commandtype))
            {
                consumersbycommand.Add(commandtype, new List<UICommandHandler>());
            }
            consumersbycommand[commandtype].Add(handler);
        }
    }
}
