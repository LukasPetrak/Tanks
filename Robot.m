classdef Robot < handle
    properties
        Figure, Axes
        Pozadi_1, Pozadi_2
        Slider_1, Slider_2, Button
        Tank1, Tank2, Hlaven1, Hlaven2
        
        n, h, alfa, velocity
        a, b, c, d
        
        Text1, Text2, Text3

        Krivka, kx, ky
        Vitr
        body1, body2, stav
        beta
        
        Menu, Exit
        Tlacitko1, Tlacitko2
        Tlacitko3, Tlacitko4
        
        system
        Victoria, Victoria2
    end
    
    methods
        function obj = Robot()
            close all
            obj.alfa = 0;
            obj.velocity = 0;
            
            obj.kx = 0;
            obj.ky = 0;
            obj.body1 = 0;
            obj.body2 = 0;
            obj.stav = 0;
            
            %vytvoreni figury
            obj.Figure = figure;
            obj.Figure.Color = [1 0.84 0.2];
            obj.Figure.MenuBar = 'none';
            
            %vytvoreni os
            obj.Axes = axes('Parent',obj.Figure,...
                            'Units','normalized',...
                            'XLim',[0 1500],...
                            'YLim',[400 550],...
                            'Position',[0.05 0.3 0.9 0.65]);
                                  
                        
            %vytvoreni polynomu na pozadi
            [n,h] = newton();
            obj.n = n;                              %rozsah [x]
            obj.h = h;                              %rozsah [y]
            
            obj.h(1) = 550;
            obj.h(length(obj.n)) = 550;
            obj.Pozadi_2 = fill(obj.Axes, obj.n, obj.h, [0.3010 0.7450 0.9330]);
            hold on
            
            %tanky
            t1 = [145 146 150 151 174 175 198 199 209 210];
            t55 = [460 462 462 464 464 466 466 463 463 460];
            
            obj.Tank1 = fill(t1,t55,[0 0.4470 0.7410]);
            
            t2 = [1030 1031 1041 1042 1065 1066 1089 1090 1094 1095];
            t54 = [478 481 481 484 484 482 482 480 480 478];
            
            obj.Tank2 = fill(t2,t54,[0.4940 0.1840 0.5560]);
            
            obj.a = [198 248];
            obj.b = [464 464];
            
            %hlavne
            obj.Hlaven1 = line('Parent',obj.Axes,...
                               'XData',obj.a,...
                               'YData',obj.b,...
                               'LineWidth',3,...
                               'Color',[0 0.4470 0.7410]);
                           
            obj.c = [992 1042];
            obj.d = [482 482];
            
            obj.Hlaven2 = line('Parent',obj.Axes,...
                               'XData',obj.c,...
                               'YData',obj.d,...
                               'LineWidth',3,...
                               'Color',[0.4940 0.1840 0.5560]);
            
            obj.h(1) = 0;
            obj.h(length(obj.n)) = 0;
            obj.Pozadi_1 = fill(obj.Axes, obj.n, obj.h, [0.2 0.6740 0.1880]);
            
            %nastaveni Y-osy vuci X-ose v pomeru 1:10
            obj.Axes.XLim = [0 1500];
            obj.Axes.YLim = [400 550];
            obj.Axes.Visible = 'off';

            
            %vytvoreni menu
            obj.Menu = uibuttongroup('Visible','on',...
                                     'Position',[0 0 1 1],...
                                     'BackgroundColor',[1 0.84 0.2]);
                                 
            obj.Tlacitko1 = uicontrol(obj.Menu,'Style','pushbutton',...
                                               'String','EASY',...
                                               'Units','normalized',...
                                               'Position',[0.25 0.8 0.5 0.07],...
                                               'BackgroundColor',[1 1 0],...
                                               'FontSize',[20],...
                                               'FontName','DejaVu Sans',...
                                               'FontWeight','bold',...
                                               'Callback',{@obj.menu_select1,obj.system});
                         
            obj.Tlacitko2 = uicontrol(obj.Menu,'Style','pushbutton',...
                                               'String','MEDIUM',...
                                               'Units','normalized',...
                                               'Position',[0.25 0.6 0.5 0.07],...
                                               'BackgroundColor',[1 0.7 0],...
                                               'FontSize',[16],...
                                               'FontName','DejaVu Sans',...
                                               'FontWeight','bold',...
                                               'Callback',{@obj.menu_select2,obj.system});
                         
            obj.Tlacitko3 = uicontrol(obj.Menu,'Style','pushbutton',...
                                               'String','HARD',...
                                               'Units','normalized',...
                                               'Position',[0.25 0.4 0.5 0.07],...
                                               'BackgroundColor',[1 0.4 0],...
                                               'FontSize',[13],...
                                               'FontName','DejaVu Sans',...
                                               'FontWeight','bold',...
                                               'Callback',{@obj.menu_select3,obj.system});
                         
            obj.Tlacitko4 = uicontrol(obj.Menu,'Style','pushbutton',...
                                               'String','EXPERT',...
                                               'Units','normalized',...
                                               'Position',[0.25 0.2 0.5 0.07],...
                                               'BackgroundColor',[1 0 0],...
                                               'FontSize',[10],...
                                               'FontName','DejaVu Sans',...
                                               'FontWeight','bold',...
                                               'Callback',{@obj.menu_select4,obj.system});
                                           
            obj.Exit = uicontrol('Parent',obj.Figure,...
                                 'Units','normalized',...
                                 'Position',[0.84 0.89 0.1 0.04],...
                                 'Style','pushbutton',...
                                 'FontSize',[10],...
                                 'FontName','DejaVu Sans',...
                                 'FontWeight','bold',...
                                 'String','exit',...
                                 'BackgroundColor',[0.3010 0.7450 0.9330],...
                                 'Visible','off',...
                                 'Callback',{@obj.exit_call,obj.alfa,obj.beta,obj.velocity,obj.body1,obj.body2,obj.stav,obj.a,obj.b,obj.c,obj.d});                
               
            obj.Victoria = uicontrol('Parent',obj.Figure,...
                                    'Units','normalized',...
                                    'Position',[0 0 1 1],...
                                    'Style','text',...
                                    'FontSize',[70],...
                                    'FontName','DejaVu Sans',...
                                    'FontWeight','bold',...
                                    'HorizontalAlignment','center',...
                                    'BackgroundColor',[1 0.84 0.2],...
                                    'Visible','off');
                                
            obj.Victoria2 = uicontrol('Parent',obj.Figure,...
                                      'Units','normalized',...
                                      'Position',[0 0 1 0.4],...
                                      'Style','text',...
                                      'FontSize',[27],...
                                      'FontName','DejaVu Sans',...
                                      'FontWeight','bold',...
                                      'HorizontalAlignment','center',...
                                      'BackgroundColor',[1 0.84 0.2],...
                                      'Visible','off');
                                
                                
            %prvky na pozadi
            obj.Slider_1 = uicontrol('Parent',obj.Figure,...
                                     'Style','slider',...
                                     'Max',[60],...
                                     'Min',[0],...
                                     'Visible','off',...
                                     'Units','normalized',...
                                     'Position',[0.05 0.2 0.2 0.05],...
                                     'Callback',@obj.slider1_call);
            
            obj.Slider_2 = uicontrol('Parent',obj.Figure,...
                                     'Style','slider',...
                                     'Max',[350],...
                                     'Min',[0],...
                                     'Visible','off',...
                                     'Units','normalized',...
                                     'Position',[0.75 0.2 0.2 0.05],...
                                     'Callback',@obj.slider2_call);
                                 
            obj.Text1 = uicontrol('Parent',obj.Figure,...
                                  'Style','text',...
                                  'BackgroundColor',[0.9290 0.6940 0.1250],...
                                  'FontName','DejaVu Sans',...
                                  'FontWeight','bold',...
                                  'String',{'ÚHEL' '0'},...
                                  'Visible','off',...
                                  'Units','normalized',...
                                  'Position',[0.05 0.1 0.2 0.1]);
                                  
            obj.Text2 = uicontrol('Parent',obj.Figure,...
                                  'Style','text',...
                                  'BackgroundColor',[0.9290 0.6940 0.1250],...
                                  'FontName','DejaVu Sans',...
                                  'FontWeight','bold',...
                                  'String',{'RYCHLOST' '0'},...
                                  'Visible','off',...
                                  'Units','normalized',...
                                  'Position',[0.75 0.1 0.2 0.1]);
                              
            obj.Text3 = uicontrol('Parent',obj.Figure,...
                                  'Style','text',...
                                  'BackgroundColor',[0.9290 0.6940 0.1250],...
                                  'FontSize',11,...
                                  'FontName','DejaVu Sans',...
                                  'FontWeight','bold',...
                                  'String',{[num2str(obj.body1),'     STAV    ',num2str(obj.body2)] 'Na øadì je modrý tank'},...
                                  'Visible','off',...
                                  'Units','normalized',...
                                  'Position',[0.3 0.05 0.4 0.175]);                                    
                              
            obj.Button = uicontrol('Parent',obj.Figure,...
                                   'Visible','off',...
                                   'Units','normalized',...
                                   'Position',[0.375 0.07 0.25 0.05],...
                                   'Style','pushbutton',...
                                   'FontSize',10,...
                                   'FontName','DejaVu Sans',...
                                   'FontWeight','bold',...
                                   'BackgroundColor',[0 1 0],...
                                   'String','Výstøel',...
                                   'Interruptible','off',...
                                   'BusyAction','cancel',...
                                   'Callback',{@obj.button_call,obj.velocity,obj.alfa,obj.a,obj.b,obj.c,obj.d,obj.kx,obj.ky,obj.h,obj.n,obj.body1,obj.body2,obj.stav,obj.beta,obj.Pozadi_1,obj.system});                  
              
            obj.Krivka = line('Parent',obj.Axes,...
                              'XData',obj.kx,...
                              'YData',obj.ky,...
                              'LineWidth',1,...
                              'Color','red');
             
            obj.Vitr = uicontrol('Parent',obj.Figure,...
                                 'Style','text',...
                                 'Visible','off',...
                                 'Units','normalized',...
                                 'Position',[0.06 0.86 0.14 0.07],...
                                 'BackgroundColor',[0.3010 0.7450 0.9330],...
                                 'FontSize',10,...
                                 'FontName','DejaVu Sans',...
                                 'FontWeight','bold',...
                                 'String',' 0 m/s' );
                                 
        end
        
        function [system] = menu_select1(obj,handle,eventdata,system)          
            obj.Menu.Visible = 'off';
            obj.beta = randi([30,60],1);
            obj.system = 1;
            
            obj.Text1.Visible = 'on';
            obj.Text2.Visible = 'on';
            obj.Text3.Visible = 'on';
            obj.Slider_1.Visible = 'on';
            obj.Slider_2.Visible = 'on';
            obj.Button.Visible = 'on';                 
            obj.Vitr.Visible = 'on';
            obj.Exit.Visible = 'on';
        end
        
        function [system] = menu_select2(obj,handle,eventdata,system)          
            obj.Menu.Visible = 'off';
            obj.beta = randi([35,55],1);
            obj.system = 0;
            
            obj.Text1.Visible = 'on';
            obj.Text2.Visible = 'on';
            obj.Text3.Visible = 'on';
            obj.Slider_1.Visible = 'on';
            obj.Slider_2.Visible = 'on';
            obj.Button.Visible = 'on';                 
            obj.Vitr.Visible = 'on';
            obj.Exit.Visible = 'on';
        end
        
        function [system] = menu_select3(obj,handle,eventdata,system)          
            obj.Menu.Visible = 'off';
            obj.beta = randi([40,50],1);
            obj.system = 0;
            
            obj.Text1.Visible = 'on';
            obj.Text2.Visible = 'on';
            obj.Text3.Visible = 'on';
            obj.Slider_1.Visible = 'on';
            obj.Slider_2.Visible = 'on';
            obj.Button.Visible = 'on';                 
            obj.Vitr.Visible = 'on';
            obj.Exit.Visible = 'on';
        end
        
        function [system] = menu_select4(obj,handle,eventdata,system)          
            obj.Menu.Visible = 'off';
            obj.beta = 46.8;
            obj.system = 2;
            
            obj.Text1.Visible = 'on';
            obj.Text2.Visible = 'on';
            obj.Text3.Visible = 'on';
            obj.Slider_1.Visible = 'on';
            obj.Slider_2.Visible = 'on';
            obj.Button.Visible = 'on';                 
            obj.Vitr.Visible = 'on';
            obj.Exit.Visible = 'on';
        end
        
        function [alfa, a, b] = slider1_call(obj,handle,eventdata)
            obj.alfa = handle.Value
            
            %vykreslovani pod uhlem
            obj.a = [198 (248-50*sind(obj.alfa))];
            obj.b = [464 (464+4.6*sind(obj.alfa)+5*sind(obj.alfa))];
            
            set(obj.Hlaven1,'XData',obj.a);
            set(obj.Hlaven1,'YData',obj.b);
            
            obj.Text1.String = [{'UHEL' num2str(handle.Value)}];
        end
        
        function [velocity] = slider2_call(obj,handle,eventdata)
            obj.velocity = handle.Value
            
            obj.Text2.String = [{'RYCHLOST' num2str(handle.Value)}];
        end
        
        %jadro hry
        function [kx,ky] = button_call(obj,handle,eventdata,velocity,alfa,a,b,c,d,kx,ky,n,h,body1,body2,stav,beta,Pozadi_1,system)
            %pocatecni podminky
            uhel = obj.alfa;
            v0 = obj.velocity;
            x0 = obj.a(2);
            y0 = obj.b(2);
            body1 = obj.body1;
            
            [t_s,x_s,body1,deltaV,n,h] = balisticka(uhel,v0,x0,y0,body1);
            
            obj.h(1) = 0;
            obj.h(length(obj.n)) = 0;
            obj.Pozadi_1 = fill(obj.Axes, obj.n, obj.h, [0.2 0.6740 0.1880]);
            
            %smer vetru
            if deltaV > 0
                set(obj.Vitr,'String',{[num2str(round(deltaV)) 'm/s'],'>>'});
            else
                set(obj.Vitr,'String',{[num2str(round(deltaV)) 'm/s'],'<<'});
            end

            obj.kx = x_s(:,1);
            obj.ky = x_s(:,3);
            obj.body1 = body1;
            
            set(obj.Krivka,'XData',obj.kx);
            set(obj.Krivka,'YData',obj.ky);
            
            set(obj.Text3,'String',{[num2str(obj.body1) '     STAV    ' num2str(obj.body2)] 'Na øadì je fial. tank'});
            
            pause(4);
            
            
            %BOT!!!
            
            %system na nalezeni cile
            switch obj.system
                
                %puleni intervalu
                case 0
                    switch obj.stav
                        case 1
                            obj.beta = (3/2)*obj.beta;
                        case 2
                            obj.beta = obj.beta;
                        case 3
                            obj.beta = obj.beta/2;
                    end
                
                %postupne priblizovani
                case 1
                    switch obj.stav
                        case 1
                            if obj.beta < 40
                                obj.beta = obj.beta + 2.5;
                            elseif obj.beta < 43
                                obj.beta = obj.beta + 1.5;
                            else
                                obj.beta = obj.beta + 1;
                            end
                        case 2
                            obj.beta = obj.beta;
                        case 3
                            if obj.beta > 50
                                obj.beta = obj.beta - 2.5;
                            elseif obj.beta > 48
                                obj.beta = obj.beta - 1.5;
                            else
                                obj.beta = obj.beta - 1;
                            end
                    end
                    
                case 2
                    obj.beta = obj.beta;
                
            end
            
            %nastaveni hlavne2
            obj.c = [(992+50*sind(obj.beta)) 1042];
            obj.d = [(482+4.6*sind(obj.beta)+5*sind(obj.beta)) 482];
            
            set(obj.Hlaven2,'XData',obj.c);
            set(obj.Hlaven2,'YData',obj.d);
            
            %pocatecni podminky
            uhel = obj.beta;
            x0 = obj.c(1);
            y0 = obj.d(1);
            body2 = obj.body2;
            
            [t_s,x_s,body2] = balisticka2(uhel,x0,y0,body2);

            obj.kx = x_s(:,1);
            obj.ky = x_s(:,3);
            obj.body2 = body2;
            
            set(obj.Krivka,'XData',obj.kx);
            set(obj.Krivka,'YData',obj.ky);
            
            %overeni zasahu
            if x_s(length(t_s),1) > 210
                obj.stav = 1;

            elseif (x_s(length(t_s),1) >= 145) && (x_s(length(t_s),1) <= 210)
                obj.stav = 2;

            elseif x_s(length(t_s),1) < 145
                obj.stav = 3;
            end

            obj.stav
            obj.beta
            
            set(obj.Text3,'String',{[num2str(obj.body1) '     STAV    ' num2str(obj.body2)] 'Na øadì je modrý tank'});
            
            pause(4)
            
            
            %dalsi kolo
            set(obj.Krivka,'XData',0);
            set(obj.Krivka,'YData',0);
            
            %ukonceni hry
            if (obj.body1 >= 5) || (obj.body2 >= 5)
                obj.Tlacitko1.Visible = 'off';
                obj.Tlacitko2.Visible = 'off';
                obj.Tlacitko3.Visible = 'off';
                obj.Tlacitko4.Visible = 'off';
                
                [alfa,beta,velocity,body1,body2,stav,a,b,c,d] = exit_call(obj,handle,eventdata,alfa,beta,velocity,body1,body2,stav,a,b,c,d);
            end
        end
        
        function [alfa,beta,velocity,body1,body2,stav,a,b,c,d] = exit_call(obj,handle,eventdata,alfa,beta,velocity,body1,body2,stav,a,b,c,d)
            obj.Menu.Visible = 'on';
            set(obj.Victoria,'Visible','on');
            set(obj.Victoria2,'Visible','on');
            
            %stav po ukonceni
            if (obj.body1 >= 5) && (obj.body2 >= 5)
                set(obj.Victoria,'String',':)NOONE:(');
                set(obj.Victoria2,'String','...Status quo...');
            elseif obj.body1 >= 5
                set(obj.Victoria,'String',' VICTORY:)');
                set(obj.Victoria2,'String','...ad astra per aspera...');
            else
                set(obj.Victoria,'String','DEFEATED:(');
                set(obj.Victoria2,'String','...ave atque vale...');
            end
            
            %inicializace vsech parametru
            obj.Text1.Visible = 'off';
            obj.Text2.Visible = 'off';
            obj.Slider_1.Visible = 'off';
            obj.Slider_2.Visible = 'off';
            obj.Button.Visible = 'off';                 
            obj.Vitr.Visible = 'off';
            obj.Exit.Visible = 'off';
            
            obj.Slider_1.Value = 0;
            obj.Slider_2.Value = 0;
            obj.Text1.String = {'UHEL' '0'};
            obj.Text2.String = {'RYCHLOST' '0'};
            obj.Vitr.String = ' 0 m/s';
            
            obj.alfa = 0;
            obj.beta = 0;
            obj.velocity = 0;
            obj.body1 = 0;
            obj.body2 = 0;
            obj.stav = 0;
            
            obj.a = [198 248];
            obj.b = [464 464];
            obj.c = [992 1042];
            obj.d = [482 482];
            
            obj.Hlaven1.XData = obj.a;
            obj.Hlaven1.YData = obj.b;
            obj.Hlaven2.XData = obj.c;
            obj.Hlaven2.YData = obj.d;
            
            
            %navrat do menu
            pause(4)
            set(obj.Victoria,'Visible','off');
            set(obj.Victoria2,'Visible','off');
            
            obj.Text3.Visible = 'off';
            obj.Text3.String = {['0','     STAV    ','0'] 'Na øadì je modrý tank'};
            
            obj.Tlacitko1.Visible = 'on';
            obj.Tlacitko2.Visible = 'on';
            obj.Tlacitko3.Visible = 'on';
            obj.Tlacitko4.Visible = 'on';
        end
        
    end
end
