function plot_boundary(x,theta)
   
    hold on
    max_x1 = max(x(:,2))+1;
    min_x1 = min(x(:,2))-1;
    max_x2 = max(x(:,3));
    min_x2 = min(x(:,3));
    
    %decision_boundary --- theta(1) + theta(2)*x1 + theta(3)*x2 = 0 where
    %theta(1) is theta_0, theta(2) is theta_1 and theta(3) is theta_2
   
    %y1 = 0.0;
    x2 = (-theta(1) - theta(2)*min_x1)/theta(3);
    y1 = x2;
    
    
    % modify this: modified y2
    %y2 = 0.0;
    x2 = (-theta(1) - theta(2)*max_x1)/theta(3);
    y2 = x2;
   
    
    
    plot([min_x1,max_x1],[y1,y2],'-')
    xlabel('x1')
    ylabel('x2')
    
end
    
    %END OF FUNCTION