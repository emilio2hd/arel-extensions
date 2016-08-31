module ArelExtensions
  module Visitors
    Arel::Visitors::PostgreSQL.class_eval do

      def visit_ArelExtensions_Nodes_Rand o, collector
        collector << "random("
        if(o.left != nil && o.right != nil)
          collector = visit o.left, collector
          collector << Arel::Visitors::PostgreSQL::COMMA
          collector = isit o.right, collector
        end
        collector << ")"
        collector
      end

      remove_method(:visit_Arel_Nodes_Regexp) rescue nil
      def visit_Arel_Nodes_Regexp o, collector
        collector = visit o.left, collector
        collector << " ~ "
        collector = visit o.right, collector
        collector
      end

      remove_method(:visit_Arel_Nodes_NotRegexp) rescue nil
      def visit_Arel_Nodes_NotRegexp o, collector
        collector = visit o.left, collector
        collector << " !~ "
        collector = visit o.right, collector
        collector
      end

      def visit_ArelExtensions_Nodes_Trim o, collector
          collector << 'TRIM(BOTH '
          collector = visit o.right, collector
          collector << " FROM "
          collector = visit o.left, collector
          collector << ")"
          collector
      end

      def visit_ArelExtensions_Nodes_Ltrim o, collector
          collector << 'TRIM(LEADING '
          collector = visit o.right, collector
          collector << " FROM "
          collector = visit o.left, collector
          collector << ")"
          collector
      end

      def visit_ArelExtensions_Nodes_Rtrim o, collector
        collector << 'TRIM(TRAILING '
        collector = visit o.right, collector
        collector << " FROM "
        collector = visit o.left, collector
        collector << ")"
        collector
      end

      def visit_ArelExtensions_Nodes_DateAdd o, collector
        collector = visit o.left, collector
        collector << " + "
        collector << "date "
        collector = visit o.right, collector
        collector
      end

      def visit_ArelExtensions_Nodes_DateDiff o, collector
        collector = visit o.left, collector
        collector << " - "
        collector << "date "
        collector = visit o.right, collector
        collector
      end


      def visit_ArelExtensions_Nodes_Duration o, collector
        #visit left for period
        if o.left == "d"
          collector << "EXTRACT(DAY FROM"
        elsif o.left == "m"
          collector << "EXTRACT(MONTH FROM "
        elsif (o.left == "w")
          collector << "EXTRACT(WEEK FROM"
        elsif (o.left == "y")
          collector << "EXTRACT(YEAR FROM"
        end
        #visit right
        collector = visit o.right, collector
        collector << ")"
        collector
      end

      def visit_ArelExtensions_Nodes_Locate o, collector
        collector << "POSITION("
        collector = visit o.right, collector
        collector << " IN "
        collector = visit o.left, collector
        collector << ")"
        collector
      end


      def visit_ArelExtensions_Nodes_Replace o, collector
        collector << "REPLACE("
        collector = visit o.expr,collector
        collector << Arel::Visitors::PostgreSQL::COMMA
        collector = visit o.left, collector
        collector << Arel::Visitors::PostgreSQL::COMMA
        collector = visit o.right, collector
        collector << ")"
        collector
      end

      def visit_ArelExtensions_Nodes_Isnull o, collector
        collector << "COALESCE("
        collector = visit o.left, collector
        collector << Arel::Visitors::PostgreSQL::COMMA
        collector = visit o.right, collector
        collector << ")"
        collector
      end


      def visit_ArelExtensions_Nodes_Sum o, collector
        collector << "sum("
        collector = visit o.expr, collector
        collector << ")"
        collector
      end

      def visit_ArelExtensions_Nodes_Wday o, collector
        collector << "date_part('dow', "
        if((o.date).is_a?(Arel::Attributes::Attribute))
          collector = visit o.date, collector
        else
          collector << "'#{o.date}'"
        end
        collector << ")"
        collector
      end

    end
  end
end